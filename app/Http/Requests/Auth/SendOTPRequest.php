<?php

namespace App\Http\Requests\Auth;

use Illuminate\Foundation\Http\FormRequest;

class SendOTPRequest extends FormRequest
{
    public function authorize()
    {
        return true;
    }

    public function rules()
    {
        return [
            'email' => 'required|email|unique:users',
            'firstName' => 'required|string',
            'lastName' => 'required|string',
            'password' => 'required|string|min:8',
            'role_id' => 'required|exists:roles,id',
            'student_id' => 'nullable|string',
            'course_id' => 'nullable|string',
        ];
    }
}
