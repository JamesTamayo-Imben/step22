import { useState } from 'react';
import { Mail, MapPin, User, Facebook, Github } from 'lucide-react';

export default function ContactUs() {
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [message, setMessage] = useState('');
  const [submitted, setSubmitted] = useState(false);

  const submitForm = (event) => {
    event.preventDefault();
    setSubmitted(true);
    setTimeout(() => setSubmitted(false), 2500);
  };

  return (
    <section className="min-h-screen bg-slate-50 py-20 px-4 sm:px-6 lg:px-8">
      <div className="max-w-6xl mx-auto bg-white/70 backdrop-blur-xl border border-white/40 rounded-2xl shadow-xl p-8 lg:p-16">
        <div className="text-center mb-12">
          <h1 className="text-4xl font-bold text-slate-900">Get in Touch</h1>
          <p className="mt-3 text-lg text-slate-600">Built for Transparency and Accountability.</p>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
          <form onSubmit={submitForm} className="space-y-4">
            <div className="bg-white/70 border border-slate-200 rounded-xl p-6 shadow-sm">
              <label className="block text-sm font-medium text-slate-700">Name</label>
              <div className="mt-1 relative">
                <input
                  type="text"
                  value={name}
                  onChange={(e) => setName(e.target.value)}
                  required
                  placeholder="Your full name"
                  className="block w-full rounded-lg border border-slate-300 px-4 py-2 outline-none focus:border-blue-700 focus:ring-2 focus:ring-blue-100"
                />
                <User className="absolute right-3 top-1/2 w-5 h-5 text-slate-400 -translate-y-1/2" />
              </div>
            </div>

            <div className="bg-white/70 border border-slate-200 rounded-xl p-6 shadow-sm">
              <label className="block text-sm font-medium text-slate-700">Email</label>
              <div className="mt-1 relative">
                <input
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  required
                  placeholder="name@example.com"
                  className="block w-full rounded-lg border border-slate-300 px-4 py-2 outline-none focus:border-blue-700 focus:ring-2 focus:ring-blue-100"
                />
                <Mail className="absolute right-3 top-1/2 w-5 h-5 text-slate-400 -translate-y-1/2" />
              </div>
            </div>

            <div className="bg-white/70 border border-slate-200 rounded-xl p-6 shadow-sm">
              <label className="block text-sm font-medium text-slate-700">Message</label>
              <textarea
                value={message}
                onChange={(e) => setMessage(e.target.value)}
                required
                rows={5}
                placeholder="Your question or feedback"
                className="mt-1 block w-full rounded-lg border border-slate-300 px-4 py-2 outline-none focus:border-blue-700 focus:ring-2 focus:ring-blue-100"
              />
            </div>

            <button
              type="submit"
              className="w-full px-5 py-3 bg-blue-700 hover:bg-blue-800 text-white font-semibold rounded-xl transition"
            >
              Submit
            </button>
            {submitted && <p className="mt-2 text-sm text-green-600">Your message has been received. We'll follow up soon.</p>}
          </form>

          <div className="bg-white/70 border border-slate-200 rounded-xl p-6 shadow-sm space-y-4">
            <h2 className="text-xl font-semibold text-slate-900">Office of Student Affairs</h2>
            <p className="text-slate-600">We support student engagement with secure, transparent workflows.</p>
            <div className="space-y-3 text-slate-700">
              <p className="flex items-center gap-2"><Mail className="w-5 h-5 text-blue-600" /> studentaffairs@step.myschool.edu</p>
              <p className="flex items-center gap-2"><MapPin className="w-5 h-5 text-blue-600" /> 2nd Floor, Admin Building, KLD Campus</p>
              <p className="flex items-center gap-2"><User className="w-5 h-5 text-blue-600" /> Mon-Fri 8AM - 5PM</p>
            </div>
          </div>
        </div>

        <div className="mt-24 mb-16 text-center">
          <h2 className="text-4xl font-bold text-slate-900">Our Team</h2>
          <p className="mt-2 text-slate-600">Need direct system support? Reach out via email or our support channels.</p>
          <div className="mt-3 flex items-center justify-center gap-3">
            <a href="mailto:support@step.system.page" className="inline-flex items-center gap-2 px-4 py-2 rounded-lg border border-blue-200 bg-blue-50 text-blue-700 hover:bg-blue-100 transition">
              <Mail className="w-4 h-4" /> Email Support
            </a>
            <a href="https://www.facebook.com/stepsupport" target="_blank" rel="noreferrer" className="inline-flex items-center gap-2 px-4 py-2 rounded-lg border border-blue-200 bg-blue-50 text-blue-700 hover:bg-blue-100 transition">
              <Facebook className="w-4 h-4" /> Facebook Page
            </a>
          </div>
        </div>

        <div className="mt-6 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          <div className="bg-white/60 border border-white/30 rounded-xl p-6 text-center shadow-md">
            <div className="mx-auto mb-4 w-16 h-16 rounded-full bg-blue-100 flex items-center justify-center text-blue-600 text-lg font-bold">J</div>
            <h3 className="text-xl font-semibold">James</h3>
            <p className="mt-1 text-sm text-slate-600">Full Stack Developer (Backend & Frontend) – Expert in Immutable Logic & React UI Development.</p>
            <div className="mt-4 flex items-center justify-center gap-2">
              <a href="mailto:james@example.com" className="p-2 rounded-lg bg-blue-50 hover:bg-blue-100 text-blue-700" aria-label="Email James"><Mail className="w-4 h-4" /></a>
              <a href="https://www.facebook.com/james" target="_blank" rel="noreferrer" className="p-2 rounded-lg bg-blue-50 hover:bg-blue-100 text-blue-700" aria-label="James Facebook"><Facebook className="w-4 h-4" /></a>
              <a href="https://github.com/james" target="_blank" rel="noreferrer" className="p-2 rounded-lg bg-blue-50 hover:bg-blue-100 text-blue-700" aria-label="James GitHub"><Github className="w-4 h-4" /></a>
            </div>
          </div>
          <div className="bg-white/60 border border-white/30 rounded-xl p-6 text-center shadow-md">
            <div className="mx-auto mb-4 w-16 h-16 rounded-full bg-blue-100 flex items-center justify-center text-blue-600 text-lg font-bold">J</div>
            <h3 className="text-xl font-semibold">Jhonny</h3>
            <p className="mt-1 text-sm text-slate-600">Project Manager & Lead Systems Architect – System Flow Designer & Database Architecture Specialist.</p>
            <div className="mt-4 flex items-center justify-center gap-2">
              <a href="mailto:jhonny@example.com" className="p-2 rounded-lg bg-blue-50 hover:bg-blue-100 text-blue-700" aria-label="Email Jhonny"><Mail className="w-4 h-4" /></a>
              <a href="https://www.facebook.com/jhonny" target="_blank" rel="noreferrer" className="p-2 rounded-lg bg-blue-50 hover:bg-blue-100 text-blue-700" aria-label="Jhonny Facebook"><Facebook className="w-4 h-4" /></a>
              <a href="https://github.com/jhonny" target="_blank" rel="noreferrer" className="p-2 rounded-lg bg-blue-50 hover:bg-blue-100 text-blue-700" aria-label="Jhonny GitHub"><Github className="w-4 h-4" /></a>
            </div>
          </div>
          <div className="bg-white/60 border border-white/30 rounded-xl p-6 text-center shadow-md">
            <div className="mx-auto mb-4 w-16 h-16 rounded-full bg-blue-100 flex items-center justify-center text-blue-600 text-lg font-bold">L</div>
            <h3 className="text-xl font-semibold">Lawrence</h3>
            <p className="mt-1 text-sm text-slate-600">QA & UI/UX Designer – Figma-to-Code Translation & System Reliability Specialist.</p>
            <div className="mt-4 flex items-center justify-center gap-2">
              <a href="mailto:lawrence@example.com" className="p-2 rounded-lg bg-blue-50 hover:bg-blue-100 text-blue-700" aria-label="Email Lawrence"><Mail className="w-4 h-4" /></a>
              <a href="https://www.facebook.com/lawrence" target="_blank" rel="noreferrer" className="p-2 rounded-lg bg-blue-50 hover:bg-blue-100 text-blue-700" aria-label="Lawrence Facebook"><Facebook className="w-4 h-4" /></a>
              <a href="https://github.com/lawrence" target="_blank" rel="noreferrer" className="p-2 rounded-lg bg-blue-50 hover:bg-blue-100 text-blue-700" aria-label="Lawrence GitHub"><Github className="w-4 h-4" /></a>
            </div>
          </div>
          <div className="bg-white/60 border border-white/30 rounded-xl p-6 text-center shadow-md">
            <div className="mx-auto mb-4 w-16 h-16 rounded-full bg-blue-100 flex items-center justify-center text-blue-600 text-lg font-bold">E</div>
            <h3 className="text-xl font-semibold">Edward</h3>
            <p className="mt-1 text-sm text-slate-600">Technical Writer & Documentation Lead – Research Lead & Technical Documentation Architect.</p>
            <div className="mt-4 flex items-center justify-center gap-2">
              <a href="mailto:edward@example.com" className="p-2 rounded-lg bg-blue-50 hover:bg-blue-100 text-blue-700" aria-label="Email Edward"><Mail className="w-4 h-4" /></a>
              <a href="https://www.facebook.com/edward" target="_blank" rel="noreferrer" className="p-2 rounded-lg bg-blue-50 hover:bg-blue-100 text-blue-700" aria-label="Edward Facebook"><Facebook className="w-4 h-4" /></a>
              <a href="https://github.com/edward" target="_blank" rel="noreferrer" className="p-2 rounded-lg bg-blue-50 hover:bg-blue-100 text-blue-700" aria-label="Edward GitHub"><Github className="w-4 h-4" /></a>
            </div>
          </div>
        </div>

        <p className="mt-8 text-xs text-center text-slate-500">This portal was developed with a focus on high-security code standards and transparency logic.</p>
      </div>
    </section>
  );
}
