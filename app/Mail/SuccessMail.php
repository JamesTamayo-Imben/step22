<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class SuccessMail extends Mailable
{
    use Queueable, SerializesModels;

    public $firstName;
    public $role;
    public $instituteName;
    public $employeeId;

    /**
     * Create a new message instance.
     */
    public function __construct($firstName, $role, $instituteName = null, $employeeId = null)
    {
        $this->firstName = $firstName;
        $this->role = $role;
        $this->instituteName = $instituteName;
        $this->employeeId = $employeeId;
    }

    /**
     * Get the message envelope.
     */
    public function envelope(): Envelope
    {
        return new Envelope(
            subject: 'Welcome to STEP Platform - Registration Complete',
            from: env('MAIL_FROM_ADDRESS', 'noreply@stepplatform.com'),
        );
    }

    /**
     * Get the message content definition.
     */
    public function content(): Content
    {
        return new Content(
            view: 'emails.success',
            with: [
                'firstName' => $this->firstName,
                'role' => $this->role,
                'instituteName' => $this->instituteName,
                'employeeId' => $this->employeeId,
            ],
        );
    }

    /**
     * Get the attachments for the message.
     *
     * @return array<int, \Illuminate\Mail\Mailables\Attachment>
     */
    public function attachments(): array
    {
        return [];
    }
}
