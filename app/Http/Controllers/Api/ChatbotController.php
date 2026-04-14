<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

class ChatbotController extends Controller
{
    public function __invoke(Request $request)
    {
        $validated = $request->validate([
            'message' => 'required|string|max:2000',
        ]);

        $provider = config('services.chatbot.provider', 'openai');

        if ($provider === 'gemini') {
            return $this->handleGemini($validated['message']);
        }

        return $this->handleOpenAI($validated['message']);
    }

    private function handleOpenAI(string $userMessage)
    {
        $apiKey = config('services.openai.key');
        if (!$apiKey) {
            return response()->json(['error' => 'OpenAI API key is not configured.'], 500);
        }

        $model = config('services.openai.model', 'gpt-3.5-turbo');
        $systemPrompt = config('services.chatbot.system_prompt', 'You are a helpful student assistant that answers questions about projects, meetings, badges, and student account workflows.');

        $response = Http::withToken($apiKey)
            ->timeout(30)
            ->post('https://api.openai.com/v1/chat/completions', [
                'model' => $model,
                'messages' => [
                    ['role' => 'system', 'content' => $systemPrompt],
                    ['role' => 'user', 'content' => $userMessage],
                ],
                'temperature' => 0.6,
                'max_tokens' => 300,
            ]);

        if ($response->failed()) {
            return response()->json([
                'error' => 'OpenAI request failed.',
                'details' => $response->body(),
            ], 500);
        }

        $payload = $response->json();
        $reply = $payload['choices'][0]['message']['content'] ?? null;

        return response()->json([
            'reply' => $reply ?? 'Sorry, I could not generate an answer at this time.',
        ]);
    }

    private function handleGemini(string $userMessage)
    {
        $apiKey = config('services.gemini.key');
        if (!$apiKey) {
            return response()->json(['error' => 'Gemini API key is not configured.'], 500);
        }

        $model = config('services.gemini.model', 'gemini-1.5');
        $baseUri = rtrim(config('services.gemini.base_uri', 'https://gemini.googleapis.com'), '/');
        $systemPrompt = config('services.chatbot.system_prompt', 'You are a helpful student assistant that answers questions about projects, meetings, badges, and student account workflows.');

        $endpoint = sprintf('%s/v1/models/%s:generateText?key=%s', $baseUri, $model, $apiKey);

        $response = Http::timeout(30)
            ->acceptJson()
            ->post($endpoint, [
                'prompt' => [
                    'text' => $systemPrompt . "\n\n" . $userMessage,
                ],
                'temperature' => 0.6,
                'maxOutputTokens' => 300,
            ]);

        if ($response->failed()) {
            return response()->json([
                'error' => 'Gemini request failed.',
                'details' => $response->body(),
            ], 500);
        }

        $payload = $response->json();
        $reply = $payload['candidates'][0]['output'] ?? null;

        return response()->json([
            'reply' => $reply ?? 'Sorry, I could not generate an answer at this time.',
        ]);
    }
}
