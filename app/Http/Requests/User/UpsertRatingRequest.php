<?php

namespace App\Http\Requests\User;

use Illuminate\Foundation\Http\FormRequest;

class UpsertRatingRequest extends FormRequest
{
    public function authorize()
    {
        return $this->user() !== null;
    }

    public function rules()
    {
        return [
            'satisfaction_rating' => ['required', 'integer', 'min:1', 'max:5'],
            'completeness_rating' => ['nullable', 'integer', 'min:1', 'max:5'],
            'engagement_rating' => ['nullable', 'integer', 'min:1', 'max:5'],
            'comment' => ['nullable', 'string', 'max:1000'],
        ];
    }
}
