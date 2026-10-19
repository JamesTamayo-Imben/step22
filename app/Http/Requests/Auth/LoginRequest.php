<?php

namespace App\Http\Requests\Auth;

use App\Services\LoginThrottleService;
use Illuminate\Auth\Events\Lockout;
use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;

class LoginRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'email' => ['required', 'string', 'email'],
            'password' => ['required', 'string'],
        ];
    }

    /**
     * Attempt to authenticate the request's credentials.
     *
     * @throws ValidationException
     */
    public function authenticate(): void
    {
        $this->ensureIsNotRateLimited();

        $throttle = app(LoginThrottleService::class);

        if (! Auth::attempt($this->only('email', 'password'), $this->boolean('remember'))) {
            $throttle->hit($this->email());

            throw ValidationException::withMessages([
                'email' => trans('auth.failed'),
            ]);
        }

        // Check if user is archived
        $user = Auth::user();
        if ($user && $user->archive) {
            Auth::logout();
            $throttle->hit($this->email());

            throw ValidationException::withMessages([
                'email' => 'This account is no longer available.',
            ]);
        }

        $throttle->clear($this->email());
    }

    /**
     * Ensure the login request is not rate limited.
     *
     * @throws ValidationException
     */
    public function ensureIsNotRateLimited(): void
    {
        $throttle = app(LoginThrottleService::class);
        $email = $this->email();

        if (! $throttle->tooManyAttempts($email)) {
            return;
        }

        event(new Lockout($this));

        $seconds = $throttle->availableIn($email);

        throw ValidationException::withMessages([
            'email' => trans('auth.throttle', [
                'seconds' => $seconds,
                'minutes' => ceil($seconds / 60),
            ]),
        ]);
    }

    /**
     * Get the rate limiting throttle key for the request.
     */
    public function throttleKey(): string
    {
        return Str::transliterate(Str::lower($this->email()).'|'.$this->ip());
    }

    /**
     * The normalised e-mail address used as the account throttle key.
     */
    private function email(): string
    {
        return Str::lower(trim((string) $this->input('email')));
    }
}
