<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Services\PasswordGeneratorService;
use Illuminate\Http\Request;

class PasswordGeneratorController extends Controller
{
    /**
     * Generate a strong password for the sign up / password forms.
     */
    public function generate(Request $request, PasswordGeneratorService $generator)
    {
        $minLength = (int) config('security.password_generator.min_length', 12);
        $maxLength = (int) config('security.password_generator.max_length', 64);
        $defaultLength = (int) config('security.password_generator.default_length', 16);
        $minWords = (int) config('security.password_generator.min_words', 3);
        $maxWords = (int) config('security.password_generator.max_words', 8);
        $defaultWords = (int) config('security.password_generator.default_words', 4);

        $validated = $request->validate([
            'type' => ['nullable', 'string', 'in:random,passphrase'],
            'length' => ['nullable', 'integer', 'min:'.$minLength, 'max:'.$maxLength],
            'words' => ['nullable', 'integer', 'min:'.$minWords, 'max:'.$maxWords],
        ], [
            'length.min' => "The password length must be at least {$minLength} characters.",
            'length.max' => "The password length may not be greater than {$maxLength} characters.",
            'words.min' => "A passphrase must contain at least {$minWords} words.",
            'words.max' => "A passphrase may not contain more than {$maxWords} words.",
        ]);

        $type = $validated['type'] ?? 'random';

        $password = $type === 'passphrase'
            ? $generator->passphrase((int) ($validated['words'] ?? $defaultWords))
            : $generator->generate((int) ($validated['length'] ?? $defaultLength));

        return response()->json([
            'success' => true,
            'password' => $password,
            'strength' => $generator->strength($password),
        ]);
    }
}
