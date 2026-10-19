import { useState } from "react";
import { Lock, Eye, EyeOff, RefreshCw, Wand2 } from "lucide-react";
import {
  estimateStrength,
  STRENGTH_COLORS,
  STRENGTH_TEXT_COLORS,
} from "../utils/passwordStrength";

/**
 * Password input with a "Generate" button and a live strength meter.
 *
 * The generated password comes from POST /api/password/generate so the
 * strength shown to the user is the same calculation the server performs.
 */
export default function PasswordField({
  label,
  value,
  onChange,
  placeholder = "Min. 8 characters",
  id,
  autoComplete = "new-password",
  showMeter = true,
  showGenerator = true,
  required = false,
  hint = "",
  className = "",
}) {
  const [showPassword, setShowPassword] = useState(false);
  const [isGenerating, setIsGenerating] = useState(false);
  const [generatorError, setGeneratorError] = useState("");

  const strength = estimateStrength(value);

  const handleGenerate = async () => {
    setIsGenerating(true);
    setGeneratorError("");

    try {
      const response = await fetch("/api/password/generate", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Accept: "application/json",
        },
        body: JSON.stringify({ type: "random", length: 16 }),
      });

      const data = await response.json().catch(() => ({}));

      if (!response.ok || !data.password) {
        throw new Error(data.message || "Could not generate a password.");
      }

      onChange(data.password);
    } catch (err) {
      setGeneratorError(
        err.message || "Could not generate a password. Please try again."
      );
    } finally {
      setIsGenerating(false);
    }
  };

  return (
    <div>
      {label && (
        <label className="block text-sm text-gray-600 mb-1" htmlFor={id}>
          {label} {required && <span className="text-red-500">*</span>}
        </label>
      )}

      <div className="relative">
        <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
        <input
          id={id}
          type={showPassword ? "text" : "password"}
          placeholder={placeholder}
          value={value || ""}
          autoComplete={autoComplete}
          onChange={(e) => onChange(e.target.value)}
          className={`w-full h-10 pl-9 pr-20 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition ${className}`}
        />

        <div className="absolute right-2 top-1/2 -translate-y-1/2 flex items-center gap-1">
          {showGenerator && (
            <button
              type="button"
              onClick={handleGenerate}
              disabled={isGenerating}
              title="Generate a strong password"
              aria-label="Generate a strong password"
              className="text-gray-400 hover:text-blue-600 disabled:opacity-50"
            >
              {isGenerating ? (
                <RefreshCw size={16} className="animate-spin" />
              ) : (
                <Wand2 size={16} />
              )}
            </button>
          )}

          <button
            type="button"
            onClick={() => setShowPassword(!showPassword)}
            title={showPassword ? "Hide password" : "Show password"}
            aria-label={showPassword ? "Hide password" : "Show password"}
            className="text-gray-400 hover:text-gray-600"
          >
            {showPassword ? <EyeOff size={16} /> : <Eye size={16} />}
          </button>
        </div>
      </div>

      {generatorError && (
        <p className="mt-1 text-xs text-red-600">{generatorError}</p>
      )}

      {showMeter && value && (
        <div className="mt-2">
          <div className="flex items-center gap-2">
            <div className="h-1.5 flex-1 rounded-full bg-gray-200 overflow-hidden">
              <div
                className={`h-full rounded-full transition-all duration-300 ${
                  STRENGTH_COLORS[strength.score]
                }`}
                style={{ width: `${((strength.score + 1) / 5) * 100}%` }}
              />
            </div>
            <span
              className={`text-xs font-medium ${STRENGTH_TEXT_COLORS[strength.score]}`}
            >
              {strength.label}
            </span>
          </div>

          {hint && <p className="mt-1 text-xs text-gray-500">{hint}</p>}

          {strength.warnings.length > 0 && (
            <ul className="mt-1 space-y-0.5">
              {strength.warnings.slice(0, 3).map((warning) => (
                <li key={warning} className="text-xs text-gray-500">
                  • {warning}
                </li>
              ))}
            </ul>
          )}
        </div>
      )}
    </div>
  );
}
