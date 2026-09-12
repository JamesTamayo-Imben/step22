import { useMemo, useState, useRef, useEffect } from 'react';
import { usePage } from '@inertiajs/react';
import ReactDOM from 'react-dom';
import { Send, MessageSquare, X, CircleQuestionMark, Info, ShieldCheck, ChartBarIcon, MessageCircleCheckIcon, Hash, Link, Database, FileCheck, ThumbsUp, Calendar, BookOpen, Search, Eye } from 'lucide-react';

const defaultMessages = [
  {
    id: 1,
    role: 'bot',
    text: 'Hello! I am STEPH (School Transparency Engagement Portal Helper). As a Member, you have the power to monitor and verify all Central Student Government activities at KLD. I can help you navigate the public ledger, track project progress, and see how your student funds are being utilized.',
  },
];

const suggestedQuestions = [
  {
    id: 'verify',
    question: 'How do I verify a transaction?',
    icon: Search,
    answer: 'To verify a transaction, go to the "Financial Ledger" section of the project. Every approved expense has a information that yo need to compare if the data is corect. You can click on an entry to view the proof of purchase (receipt) and see the digital signature of the Adviser who approved it.'
  },
  {
    id: 'ledger_member',
    question: 'What can I see in the Ledger?',
    icon: Database,
    answer: 'As a Member, you have read-only access to all "Approved" transactions. You can see the amount, the purpose of the expense, the date, and the specific project it belongs to. This ensures that every peso of the student fund is accounted for.'
  },
  {
    id: 'project_track',
    question: 'How do I track CSG projects?',
    icon: Eye,
    answer: 'Navigate to the "Projects" tab to see a real-time list of active and completed initiatives. Because our system is immutable, you can view the entire project timeline—from the initial proposal to the final fund liquidation.'
  },
  {
    id: 'feedback_member',
    question: 'How can I give feedback?',
    icon: ThumbsUp,
    answer: 'Your voice matters! Use the "Feedback" module to rate completed projects or submit suggestions. Your feedback is recorded in our system and helps the CSG improve future student services.'
  },
  {
    id: 'security_member',
    question: 'Is the data trustworthy?',
    icon: ShieldCheck,
    answer: 'Yes. STEP uses blockchain-inspired "Append-Only" logic. This means the Council cannot delete or secretly "edit" financial records. Any change creates a new visible version, and the SHA-256 hash chain ensures that if any past data is tampered with, the system will immediately flag it.'
  }
];

const initialQuestionOption = {
  id: 'question',
  question: 'I have a question about the System',
  icon: CircleQuestionMark,
};

const concernOption = {
  id: 'concern',
  question: 'I have a concern about the System',
  icon: Info,
};

// The two concern-flow prompts that expect a free-text reply from the user,
// followed by the automatic closing/thank-you message.
const concernQuestions = [
  {
    id: 'user_concern',
    question: 'Please tell in details what is your concern about the System',
    icon: CircleQuestionMark,
  },
  {
    id: 'user_id',
    question: 'Do you want to be anonymous or you want to provide your ID for us to contact you? Y/N',
    icon: CircleQuestionMark,
  },
  {
    id: 'concern_end',
    question: 'Thank you for your concern. We will review it and get back to you as soon as possible. Your feedback is valuable to us.',
    icon: CircleQuestionMark,
  },
]

const cannedResponses = [
  {
    keywords: ['ledger', 'financial', 'money', 'budget', 'expense', 'see', 'view'],
    text: 'You can view all approved financial activities in the "Financial Ledger." While you cannot add entries, you can audit the Council’s spending by checking the attached receipts and approval timestamps.'
  },
  {
    keywords: ['receipt', 'proof', 'document', 'evidence'],
    text: 'Every transaction is backed by a "Proof Document" (usually a scanned receipt). As a Member, you can view these documents in the transaction details to ensure the reported expenses are legitimate.'
  },
  {
    keywords: ['edit', 'delete', 'change', 'remove'],
    text: 'In the STEP system, records are immutable. Neither the Council nor the Admin can delete a record once it is finalized. If a mistake is made, a new "Version" must be created, leaving the original visible for full accountability.'
  },
  {
    keywords: ['meeting', 'minutes', 'agenda', 'what happened'],
    text: 'Stay informed by visiting the "Meetings" section. You can read the minutes of the CSG sessions to understand how decisions regarding student projects and budgets were made.'
  },
  {
    keywords: ['feedback', 'rating', 'suggest', 'complain'],
    text: 'You can submit feedback or a 1-5 star rating on any completed project. Your input is crucial for transparency and helps the CSG remain responsive to student needs.'
  },
  {
    keywords: ['who', 'role', 'permissions', 'my access'],
    text: 'You are logged in as a "Member." This gives you "Read-Only" auditing privileges. You can view all approved data, projects, and meetings, but you cannot modify the ledger—ensuring the integrity of the records.'
  },
  {
    keywords: ['hash', 'sha', 'tamper', 'safe'],
    text: 'We use SHA-256 hashing to secure the data. Think of it as a "digital fingerprint." If anyone tried to change a record, the fingerprint would change, and the chain would break, alerting everyone to the tampering.'
  },
  {
    keywords: ['kld', 'school', 'csg', 'dasmarinas'],
    text: 'STEPH is the official transparency assistant for the KLD Central Student Government. Our goal is to bridge the gap between students and governance through verifiable data.'
  },
  {
    keywords: ['hello', 'hi', 'hey', 'greetings'],
    text: 'Greetings, Regals! I am STEPH. Ready to audit the ledger or check on project updates? Just let me know what you are looking for!'
  },
  {
    keywords: ['thank', 'thanks'],
    text: 'You’re welcome! Remember: Transparency is your right as a student. Feel free to explore the ledger anytime.'
  }
];

function getReply(message) {
  const normalized = message.toLowerCase();

  // Panelist/Defense special response
  if (normalized.includes('defense') || normalized.includes('panelist')) {
    return 'For the defense: STEPH is optimized for the "Member" role here. It focuses on "External Transparency"—allowing stakeholders to verify data without the ability to alter it, fulfilling the "Accountability" requirement of the ISO 25010 standard.';
  }

  for (const response of cannedResponses) {
    if (response.keywords.some((keyword) => normalized.includes(keyword))) {
      return response.text;
    }
  }

  return 'I’m here to help you navigate the portal. Try asking: "How do I verify a receipt?", "Can I see the budget?", or "How do I give feedback on a project?"';
}

export function Chatbot({ title = 'STEPH: Member Assistant' }) {
  const page = usePage();
  const isAuthenticated = Boolean(page?.props?.auth?.user);
  const [messages, setMessages] = useState(defaultMessages);
  const [inputValue, setInputValue] = useState('');
  const [isOpen, setIsOpen] = useState(false);
  const [isLoading, setIsLoading] = useState(false);

  // 'initial'  -> show the "I have a question" / "I have a concern" choices
  // 'question' -> show the list of suggested questions
  // 'concern'  -> walking through the concern free-text flow
  // 'chat'     -> free-form chat (after a question was picked, or concern flow finished)
  const [stage, setStage] = useState('initial');
  // 0 = waiting for the concern details, 1 = waiting for anonymous/ID choice
  const [concernStep, setConcernStep] = useState(0);
  const [concernDescription, setConcernDescription] = useState('');

  // Create a ref for the chat container
  const chatContainerRef = useRef(null);

  // Auto-scroll to bottom whenever messages change or loading state changes
  useEffect(() => {
    if (chatContainerRef.current) {
      chatContainerRef.current.scrollTop = chatContainerRef.current.scrollHeight;
    }
  }, [messages, isLoading, stage]);

  const firstMessage = useMemo(() => {
    return isAuthenticated ? [initialQuestionOption, concernOption] : [initialQuestionOption];
  }, [isAuthenticated]);

  const resetChat = () => {
    setMessages(defaultMessages);
    setStage('initial');
    setConcernStep(0);
    setConcernDescription('');
  };

  const handleFirstChoice = (item) => {
    const userMessage = { id: Date.now(), role: 'user', text: item.question };

    if (item.id === 'question') {
      setMessages((current) => [...current, userMessage]);
      setStage('question');
      return;
    }

    if (item.id === 'concern') {
      if (!isAuthenticated) {
        return;
      }

      const botMessage = { id: Date.now() + 1, role: 'bot', text: concernQuestions[0].question };
      setMessages((current) => [...current, userMessage, botMessage]);
      setStage('concern');
      setConcernStep(0);
    }
  };

  const handleSuggestedQuestion = (item) => {
    const userMessage = { id: Date.now(), role: 'user', text: item.question };
    const botMessage = { id: Date.now() + 1, role: 'bot', text: item.answer };
    setMessages((current) => [...current, userMessage, botMessage]);
    setStage('chat');
  };

  const handleConcernReply = async (trimmed) => {
    const userMessage = { id: Date.now(), role: 'user', text: trimmed };

    if (concernStep === 0) {
      setConcernDescription(trimmed);
      const botMessage = { id: Date.now() + 1, role: 'bot', text: concernQuestions[1].question };
      setMessages((current) => [...current, userMessage, botMessage]);
      setConcernStep(1);
      return;
    }

    setIsLoading(true);
    setMessages((current) => [...current, userMessage]);

    try {
      const normalizedContactAnswer = ['y', 'yes'].includes(trimmed.toLowerCase())
        ? 'y'
        : ['n', 'no'].includes(trimmed.toLowerCase())
          ? 'n'
          : trimmed;

      const response = await fetch('/api/concerns', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Accept: 'application/json',
          'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]')?.content || '',
        },
        credentials: 'same-origin',
        body: JSON.stringify({
          concern: concernDescription,
          contact_answer: normalizedContactAnswer,
        }),
      });

      if (!response.ok) {
        throw new Error('Failed to submit concern');
      }

      const botMessage = { id: Date.now() + 1, role: 'bot', text: concernQuestions[2].question };
      setMessages((current) => [...current, botMessage]);
      setStage('chat');
    } catch (error) {
      const botMessage = {
        id: Date.now() + 1,
        role: 'bot',
        text: 'Sorry, we could not save your concern right now. Please try again later.',
      };
      setMessages((current) => [...current, botMessage]);
      setStage('chat');
    } finally {
      setIsLoading(false);
    }
  };

  const handleSend = async () => {
    const trimmed = inputValue.trim();
    if (!trimmed) return;

    setInputValue('');

    if (stage === 'concern') {
      await handleConcernReply(trimmed);
      return;
    }

    if (stage === 'initial' || stage === 'question') {
      setStage('chat');
    }

    const userMessage = { id: Date.now(), role: 'user', text: trimmed };
    setMessages((current) => [...current, userMessage]);
    setIsLoading(true);

    setTimeout(() => {
      const botReply = { id: Date.now() + 1, role: 'bot', text: getReply(trimmed) };
      setMessages((current) => [...current, botReply]);
      setIsLoading(false);
    }, 600);
  };

  const handleKeyPress = (e) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      handleSend();
    }
  };

  const chatbotUI = (
    <div className="fixed bottom-20 right-4 sm:bottom-6 sm:right-6 z-[1000]">
      {!isOpen ? (
        <button
          type="button"
          onClick={() => { setIsOpen(true); resetChat(); }}
          className="fixed bottom-6 right-6 bg-[#2563EB] hover:bg-blue-700 text-white p-3 rounded-full shadow-lg transition-all duration-300 ease-in-out hover:scale-110 z-40"
          aria-label="Open STEPH chat"
        >
          <MessageCircleCheckIcon className="w-5 h-5" />
          {/* <img src="/images/chatbot.png" alt="STEPH Icon" className="w-5 h-5" /> */}
        </button>
      ) : (
        <div className="flex flex-col w-[calc(100vw-2rem)] max-w-sm sm:max-w-md h-[70vh] sm:h-[500px] rounded-[24px] border border-gray-100 shadow-2xl bg-white overflow-hidden">
          {/* Header */}
          <div className="flex items-center justify-between bg-gradient-to-r from-blue-800 to-blue-600 px-4 py-4 text-white">
            <div className="flex items-center gap-2">
              {/* <ShieldCheck className="w-5 h-5 text-blue-400" /> */}
              <img src="/images/chatbot.svg" alt="STEPH Icon" className="w-5 h-5" />
              <div>
                <p className="text-[#ffffff] font-normal leading-none text-[12px]"
                      style={{ fontFamily: '"Ethnocentric", "Segoe UI", sans-serif', margin: 0 }}
                    >STEPH</p>
                <p className="text-[10px] text-blue-300 mt-1 uppercase tracking-widest font-medium">School Transparency and Engagement Portal Helper</p>
              </div>
            </div>
            <button onClick={() => setIsOpen(false)} className="hover:bg-white/10 p-1 rounded-lg transition-colors">
              <X className="w-5 h-5" />
            </button>
          </div>

          {/* Chat Area */}
          <div ref={chatContainerRef} className="flex-1 p-4 overflow-y-auto space-y-4 bg-slate-50">
            {/* Always show the conversation so far */}
            {messages.map((m) => (
              <div key={m.id} className={`flex ${m.role === 'bot' ? 'justify-start' : 'justify-end'}`}>
                <div className={`max-w-full rounded-2xl px-4 py-2 text-sm ${m.role === 'bot' ? 'bg-white text-slate-800 border border-slate-200 shadow-sm' : 'bg-blue-700 text-white shadow-md'}`}>
                  {m.text}
                </div>
              </div>
            ))}

            {/* Stage-specific quick options, shown below the conversation */}
            {stage === 'initial' && (
              <div className="space-y-3">
                <p className="text-xs font-semibold text-slate-500 uppercase px-1">How can I help?</p>
                {firstMessage.map((item) => (
                  <button
                    key={item.id}
                    onClick={() => handleFirstChoice(item)}
                    className="w-full text-left p-3 bg-white rounded-xl border border-slate-200 shadow-sm hover:border-blue-400 hover:bg-blue-50 transition-all flex items-center gap-3 group"
                  >
                    <div className="p-2 bg-slate-100 rounded-lg group-hover:bg-blue-100">
                      <item.icon className="w-4 h-4 text-slate-600 group-hover:text-blue-600" />
                    </div>
                    <span className="text-sm text-slate-700 font-medium">{item.question}</span>
                  </button>
                ))}
              </div>
            )}

            {stage === 'question' && (
              <div className="space-y-3">
                <p className="text-xs font-semibold text-slate-500 uppercase px-1">Frequently Asked</p>
                {suggestedQuestions.map((item) => (
                  <button
                    key={item.id}
                    onClick={() => handleSuggestedQuestion(item)}
                    className="w-full text-left p-3 bg-white rounded-xl border border-slate-200 shadow-sm hover:border-blue-400 hover:bg-blue-50 transition-all flex items-center gap-3 group"
                  >
                    <div className="p-2 bg-slate-100 rounded-lg group-hover:bg-blue-100">
                      <item.icon className="w-4 h-4 text-slate-600 group-hover:text-blue-600" />
                    </div>
                    <span className="text-sm text-slate-700 font-medium">{item.question}</span>
                  </button>
                ))}
              </div>
            )}

            {stage === 'concern' && (
              <p className="text-xs text-slate-400 italic px-1">Type your reply below and click send.</p>
            )}

            {isLoading && (
              <div className="flex items-center gap-2 text-xs text-blue-600 font-medium animate-pulse">
                <Hash className="w-3 h-3" /> Verifying ledger integrity...
              </div>
            )}
          </div>

          {/* Input Area */}
          <div className="p-3 bg-white border-t border-slate-100">
            <div className="relative flex items-center gap-2">
              <textarea
                rows={1}
                value={inputValue}
                onChange={(e) => setInputValue(e.target.value)}
                onKeyDown={handleKeyPress}
                placeholder={stage === 'concern' ? 'Type your response...' : 'Ask about project transparency...'}
                className="flex-1 resize-none rounded-xl border border-slate-200 bg-slate-50 pl-4 pr-10 py-3 text-sm focus:bg-white focus:ring-2 focus:ring-blue-500 outline-none transition-all"
              />
              <button
                onClick={handleSend}
                disabled={isLoading || !inputValue.trim()}
                className="p-3 bg-blue-700 text-white rounded-xl hover:bg-blue-800 disabled:opacity-50 transition-colors"
              >
                <Send className="w-4 h-4" />
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );

  if (typeof document === 'undefined') {
    return chatbotUI;
  }

  return ReactDOM.createPortal(chatbotUI, document.body);
}