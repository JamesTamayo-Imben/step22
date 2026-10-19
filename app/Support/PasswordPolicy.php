<?php

namespace App\Support;

/**
 * Single source of truth for the password validation rules used across the
 * application. Tighten the switches in config/security.php to enforce a
 * stronger policy everywhere at once.
 */
class PasswordPolicy
{
    /**
     * Validation rules for a password field.
     *
     * The "required" rule is intentionally left out so the rule can be
     * combined with "confirmed" or used for optional fields.
     *
     * @return array<int, mixed>
     */
    public static function rules(): array
    {
        $rules = [
            'string',
            'min:'.self::minLength(),
            'max:'.self::maxLength(),
        ];

        if (config('security.password.require_mixed_case')) {
            $rules[] = 'regex:/[a-z]/';
            $rules[] = 'regex:/[A-Z]/';
        }

        if (config('security.password.require_numbers')) {
            $rules[] = 'regex:/\d/';
        }

        if (config('security.password.require_symbols')) {
            $rules[] = 'regex:/[^A-Za-z0-9]/';
        }

        return $rules;
    }

    /**
     * Minimum accepted password length.
     */
    public static function minLength(): int
    {
        return (int) config('security.password.min_length', 8);
    }

    /**
     * Maximum accepted password length (bcrypt truncates beyond 72 bytes).
     */
    public static function maxLength(): int
    {
        return (int) config('security.password.max_length', 72);
    }

    /**
     * Human readable messages for the password rules.
     *
     * @return array<string, string>
     */
    public static function messages(): array
    {
        return [
            'password.required' => 'A password is required.',
            'password.min' => 'The password must be at least '.self::minLength().' characters.',
            'password.max' => 'The password may not be greater than '.self::maxLength().' characters.',
        ];
    }
}
