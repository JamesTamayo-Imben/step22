<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class OnboardingWelcomeMail extends Mailable
{
    use Queueable, SerializesModels;

    public $userName;
    public $email;
    public $temporaryPassword;
    public $studentId;
    public $employeeId;
    public $role;

    /**
     * Create a new message instance.
     */
    public function __construct(
        string $userName,
        string $email,
        string $temporaryPassword,
        string $role,
        ?string $studentId = null,
        ?string $employeeId = null
    ) {
        $this->userName = $userName;
        $this->email = $email;
        $this->temporaryPassword = $temporaryPassword;
        $this->role = $role;
        $this->studentId = $studentId;
        $this->employeeId = $employeeId;
    }

    /**
     * Get the message envelope.
     */
    public function envelope(): Envelope
    {
        return new Envelope(
            subject: 'Welcome to STEP Platform - Your Temporary Password',
            from: env('MAIL_FROM_ADDRESS', 'noreply@stepplatform.com'),
        );
    }

    /**
     * Get the message content definition.
     */
    public function content(): Content
    {
        return new Content(
            view: 'emails.onboarding-welcome',
            with: [
                'userName' => $this->userName,
                'email' => $this->email,
                'temporaryPassword' => $this->temporaryPassword,
                'role' => $this->role,
                'studentId' => $this->studentId,
                'employeeId' => $this->employeeId,
            ],
        );
    }

    /**
     * Get the attachments for the message.
     */
    public function attachments(): array
    {
        return [];
    }
}
