<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class TamperingDetectedMail extends Mailable
{
    use Queueable, SerializesModels;

    public function __construct(
        public string $projectTitle,
        public string $projectId,
        public array $tamperedBlocks,
    ) {
    }

    public function envelope(): Envelope
    {
        return new Envelope(
            subject: 'STEP Intergity Testing - Tampering Detected in Blockchain',
        );
    }

    public function content(): Content
    {
        return new Content(
            view: 'emails.tampering-detected',
        );
    }

    public function attachments(): array
    {
        return [];
    }
}