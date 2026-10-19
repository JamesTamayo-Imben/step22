<?php

namespace App\Services;

use Illuminate\Support\Str;

/**
 * Cryptographically secure password generator and strength estimator.
 *
 * Every password is built with random_int() so it is safe to use for
 * temporary credentials that are mailed out to users.
 */
class PasswordGeneratorService
{
    /**
     * Ambiguous characters (l, I, 1, O, 0) are removed so generated passwords
     * can be read out loud or copied from an email without mistakes.
     */
    private const LOWERCASE = 'abcdefghijkmnopqrstuvwxyz';

    private const UPPERCASE = 'ABCDEFGHJKLMNPQRSTUVWXYZ';

    private const DIGITS = '23456789';

    private const SYMBOLS = '!@#$%^&*?-_=+';

    /**
     * Small word list used to build memorable passphrases.
     */
    private const WORDS = [
        'anchor', 'apple', 'april', 'arrow', 'badger', 'bamboo', 'basil', 'beacon',
        'bison', 'breeze', 'bridge', 'cactus', 'candle', 'canyon', 'cedar', 'cello',
        'cobalt', 'comet', 'coral', 'cosmos', 'cricket', 'dawn', 'delta', 'diamond',
        'dolphin', 'dragon', 'ember', 'falcon', 'fern', 'fjord', 'forest', 'garnet',
        'geyser', 'glacier', 'granite', 'harbor', 'hazel', 'horizon', 'jasmine', 'jasper',
        'jungle', 'kayak', 'kernel', 'lagoon', 'lantern', 'laurel', 'lilac', 'lotus',
        'lunar', 'maple', 'marble', 'meadow', 'meteor', 'mint', 'monsoon', 'nebula',
        'nectar', 'nutmeg', 'oasis', 'ocean', 'olive', 'onyx', 'orchid', 'otter',
        'pebble', 'pepper', 'piano', 'pine', 'planet', 'plum', 'poppy', 'quartz',
        'raven', 'reef', 'river', 'robin', 'saffron', 'sage', 'sandbar', 'sequoia',
        'shadow', 'silver', 'skyline', 'solstice', 'sparrow', 'spruce', 'stellar', 'summit',
        'sunset', 'thunder', 'timber', 'topaz', 'tulip', 'tundra', 'valley', 'velvet',
        'violet', 'walnut', 'willow', 'winter', 'yarrow', 'zephyr', 'zinnia', 'cactus',
    ];

    /**
     * Common passwords / sequences that are instantly guessable.
     */
    private const WEAK_PATTERNS = [
        'password', 'passw0rd', 'qwerty', 'letmein', 'welcome', 'admin', 'iloveyou',
        '123456', '12345678', '123456789', '1234567890', 'abc123', '111111', '000000',
        'secret', 'dragon', 'monkey', 'shadow', 'sunshine', 'football', 'baseball',
    ];

    /**
     * Generate a random password.
     *
     * @param  array<string, bool>  $options  use_upper, use_lower, use_digits, use_symbols
     */
    public function generate(int $length = 16, array $options = []): string
    {
        $length = $this->clampLength($length);

        $useLower = $options['use_lower'] ?? true;
        $useUpper = $options['use_upper'] ?? true;
        $useDigits = $options['use_digits'] ?? true;
        $useSymbols = $options['use_symbols'] ?? true;

        $pool = '';

        if ($useLower) {
            $pool .= self::LOWERCASE;
        }
        if ($useUpper) {
            $pool .= self::UPPERCASE;
        }
        if ($useDigits) {
            $pool .= self::DIGITS;
        }
        if ($useSymbols) {
            $pool .= self::SYMBOLS;
        }

        if ($pool === '') {
            $pool = self::LOWERCASE.self::UPPERCASE.self::DIGITS;
        }

        $password = '';

        // Guarantee at least one character from every enabled class so the
        // generated password always satisfies the strictest policy.
        $required = [];

        if ($useLower) {
            $required[] = self::LOWERCASE;
        }
        if ($useUpper) {
            $required[] = self::UPPERCASE;
        }
        if ($useDigits) {
            $required[] = self::DIGITS;
        }
        if ($useSymbols) {
            $required[] = self::SYMBOLS;
        }

        foreach ($required as $class) {
            if (strlen($password) >= $length) {
                break;
            }

            $password .= $class[random_int(0, strlen($class) - 1)];
        }

        $poolSize = strlen($pool);

        while (strlen($password) < $length) {
            $password .= $pool[random_int(0, $poolSize - 1)];
        }

        // Shuffle so the guaranteed characters are not always in front.
        return $this->shuffle($password);
    }

    /**
     * Generate a memorable passphrase such as "amber-river-lantern-otter".
     */
    public function passphrase(int $words = 4, string $separator = '-', bool $capitalize = true): string
    {
        $words = max(1, $words);
        $count = count(self::WORDS);

        $parts = [];

        for ($i = 0; $i < $words; $i++) {
            $word = self::WORDS[random_int(0, $count - 1)];

            if ($capitalize) {
                $word = Str::ucfirst($word);
            }

            $parts[] = $word;
        }

        // A random digit suffix adds entropy without hurting readability.
        $parts[] = (string) random_int(10, 99);

        return implode($separator, $parts);
    }

    /**
     * Estimate the strength of a password.
     *
     * @return array{score:int,label:string,entropy:int,requirements:array<string,bool>,warnings:array<int,string>}
     */
    public function strength(string $password): array
    {
        $length = strlen($password);

        $hasLower = (bool) preg_match('/[a-z]/', $password);
        $hasUpper = (bool) preg_match('/[A-Z]/', $password);
        $hasDigit = (bool) preg_match('/\d/', $password);
        $hasSymbol = (bool) preg_match('/[^A-Za-z0-9]/', $password);

        $pool = 0;
        $pool += $hasLower ? strlen(self::LOWERCASE) : 0;
        $pool += $hasUpper ? strlen(self::UPPERCASE) : 0;
        $pool += $hasDigit ? strlen(self::DIGITS) : 0;
        $pool += $hasSymbol ? strlen(self::SYMBOLS) : 0;

        $entropy = $length > 0 && $pool > 0
            ? (int) floor($length * log($pool, 2))
            : 0;

        $warnings = [];

        if ($length < (int) config('security.password.min_length', 8)) {
            $warnings[] = 'Use at least '.config('security.password.min_length', 8).' characters.';
        }

        if (! $hasUpper) {
            $warnings[] = 'Add an uppercase letter.';
        }

        if (! $hasLower) {
            $warnings[] = 'Add a lowercase letter.';
        }

        if (! $hasDigit) {
            $warnings[] = 'Add a number.';
        }

        if (! $hasSymbol) {
            $warnings[] = 'Add a symbol.';
        }

        $lower = Str::lower($password);

        foreach (self::WEAK_PATTERNS as $pattern) {
            if (Str::contains($lower, $pattern)) {
                $warnings[] = 'Avoid common words like "'.$pattern.'".';
                $entropy = (int) floor($entropy * 0.5);
                break;
            }
        }

        if ($this->hasSequence($password)) {
            $warnings[] = 'Avoid sequential characters such as "1234" or "abcd".';
            $entropy = (int) floor($entropy * 0.8);
        }

        if ($this->hasRepeatedCharacters($password)) {
            $entropy = (int) floor($entropy * 0.9);
        }

        $score = match (true) {
            $entropy >= 120 => 4,
            $entropy >= 80 => 3,
            $entropy >= 60 => 2,
            $entropy >= 36 => 1,
            default => 0,
        };

        $labels = ['Very weak', 'Weak', 'Fair', 'Strong', 'Very strong'];

        return [
            'score' => $score,
            'label' => $labels[$score],
            'entropy' => $entropy,
            'requirements' => [
                'length' => $length >= (int) config('security.password.min_length', 8),
                'mixed_case' => $hasLower && $hasUpper,
                'numbers' => $hasDigit,
                'symbols' => $hasSymbol,
            ],
            'warnings' => array_values(array_unique($warnings)),
        ];
    }

    /**
     * Clamp the requested length into the configured boundaries.
     */
    private function clampLength(int $length): int
    {
        $min = (int) config('security.password_generator.min_length', 12);
        $max = (int) config('security.password_generator.max_length', 64);

        return max($min, min($max, $length));
    }

    /**
     * Fisher-Yates shuffle using a cryptographically secure source.
     */
    private function shuffle(string $value): string
    {
        $characters = str_split($value);

        for ($i = count($characters) - 1; $i > 0; $i--) {
            $j = random_int(0, $i);
            [$characters[$i], $characters[$j]] = [$characters[$j], $characters[$i]];
        }

        return implode('', $characters);
    }

    /**
     * Detect ascending/descending character sequences such as "abcd" or "4321".
     */
    private function hasSequence(string $password): bool
    {
        $length = strlen($password);

        if ($length < 4) {
            return false;
        }

        for ($offset = 0; $offset + 4 <= $length; $offset++) {
            $chunk = strtolower(substr($password, $offset, 4));

            $ascending = true;
            $descending = true;

            for ($i = 1; $i < 4; $i++) {
                $diff = ord($chunk[$i]) - ord($chunk[$i - 1]);

                if ($diff !== 1) {
                    $ascending = false;
                }

                if ($diff !== -1) {
                    $descending = false;
                }
            }

            if ($ascending || $descending) {
                return true;
            }
        }

        return false;
    }

    /**
     * Detect three or more identical characters in a row.
     */
    private function hasRepeatedCharacters(string $password): bool
    {
        return (bool) preg_match('/(.)\1{2,}/', $password);
    }
}
