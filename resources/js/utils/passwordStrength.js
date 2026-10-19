/**
 * Client side password strength estimator.
 *
 * This is only a UX hint shown next to the input. The server side policy in
 * config/security.php (App\Support\PasswordPolicy) is what actually enforces
 * the rules.
 */

const LOWERCASE = "abcdefghijkmnopqrstuvwxyz";
const UPPERCASE = "ABCDEFGHJKLMNPQRSTUVWXYZ";
const DIGITS = "23456789";
const SYMBOLS = "!@#$%^&*?-_=+";

const WEAK_PATTERNS = [
  "password",
  "passw0rd",
  "qwerty",
  "letmein",
  "welcome",
  "admin",
  "iloveyou",
  "123456",
  "12345678",
  "123456789",
  "1234567890",
  "abc123",
  "111111",
  "000000",
  "secret",
];

const LABELS = ["Very weak", "Weak", "Fair", "Strong", "Very strong"];

const hasSequence = (value) => {
  const lower = value.toLowerCase();

  for (let i = 0; i + 4 <= lower.length; i++) {
    let ascending = true;
    let descending = true;

    for (let j = 1; j < 4; j++) {
      const diff = lower.charCodeAt(i + j) - lower.charCodeAt(i + j - 1);

      if (diff !== 1) ascending = false;
      if (diff !== -1) descending = false;
    }

    if (ascending || descending) return true;
  }

  return false;
};

const hasRepeatedCharacters = (value) => /(.)\1{2,}/.test(value);

/**
 * Estimate the strength of a password.
 *
 * @returns {{score: number, label: string, entropy: number, requirements: object, warnings: string[]}}
 */
export function estimateStrength(password, minLength = 8) {
  const value = password || "";
  const length = value.length;

  const hasLower = /[a-z]/.test(value);
  const hasUpper = /[A-Z]/.test(value);
  const hasDigit = /\d/.test(value);
  const hasSymbol = /[^A-Za-z0-9]/.test(value);

  let pool = 0;
  if (hasLower) pool += LOWERCASE.length;
  if (hasUpper) pool += UPPERCASE.length;
  if (hasDigit) pool += DIGITS.length;
  if (hasSymbol) pool += SYMBOLS.length;

  let entropy = length > 0 && pool > 0 ? Math.floor(length * Math.log2(pool)) : 0;

  const warnings = [];

  if (length < minLength) {
    warnings.push(`Use at least ${minLength} characters.`);
  }
  if (!hasUpper) warnings.push("Add an uppercase letter.");
  if (!hasLower) warnings.push("Add a lowercase letter.");
  if (!hasDigit) warnings.push("Add a number.");
  if (!hasSymbol) warnings.push("Add a symbol.");

  const lower = value.toLowerCase();

  if (WEAK_PATTERNS.some((pattern) => lower.includes(pattern))) {
    warnings.push('Avoid common words like "password".');
    entropy = Math.floor(entropy * 0.5);
  }

  if (hasSequence(value)) {
    warnings.push('Avoid sequential characters such as "1234" or "abcd".');
    entropy = Math.floor(entropy * 0.8);
  }

  if (hasRepeatedCharacters(value)) {
    entropy = Math.floor(entropy * 0.9);
  }

  let score = 0;
  if (entropy >= 120) score = 4;
  else if (entropy >= 80) score = 3;
  else if (entropy >= 60) score = 2;
  else if (entropy >= 36) score = 1;

  return {
    score,
    label: LABELS[score],
    entropy,
    requirements: {
      length: length >= minLength,
      mixed_case: hasLower && hasUpper,
      numbers: hasDigit,
      symbols: hasSymbol,
    },
    warnings: [...new Set(warnings)],
  };
}

export const STRENGTH_COLORS = [
  "bg-red-500",
  "bg-orange-500",
  "bg-yellow-500",
  "bg-lime-500",
  "bg-green-500",
];

export const STRENGTH_TEXT_COLORS = [
  "text-red-600",
  "text-orange-600",
  "text-yellow-600",
  "text-lime-600",
  "text-green-600",
];
