import { ArrowRight, Shield, FileCheck, Users, CheckCircle, Sparkles, Play } from 'lucide-react';
import { useRef, useState } from 'react';

const animationStyles = `
  @keyframes moveGradient {
    0% {
      background-position: 0% 50%;
    }
    50% {
      background-position: 100% 50%;
    }
    100% {
      background-position: 0% 50%;
    }
  }

  .animated-gradient {
    background: linear-gradient(-45deg, #2563EA, #1e3a8a, #3b82f6, #1e40af);
    background-size: 400% 400%;
    animation: moveGradient 8s ease infinite;
  }

  @keyframes fadeOut {
    from {
      opacity: 1;
    }
    to {
      opacity: 0;
    }
  }

  .fade-out {
    animation: fadeOut 0.5s ease-out forwards;
  }

  @keyframes fadeIn {
    from {
      opacity: 0;
    }
    to {
      opacity: 1;
    }
  }

  .fade-in {
    animation: fadeIn 0.5s ease-in forwards;
  }
`;

export default function Welcome() {
  const howItWorksRef = useRef(null);
  const videoRef = useRef(null);
  const [isVideoPlaying, setIsVideoPlaying] = useState(false);

  const scrollToHowItWorks = () => {
    howItWorksRef.current?.scrollIntoView({ behavior: 'smooth' });
  };

  const playVideo = () => {
    setIsVideoPlaying(true);
    // Video will autoplay once isVideoPlaying state changes
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-white to-blue-50">
      <style>{animationStyles}</style>
      {/* Navigation Bar */}
      <nav className="fixed top-0 left-0 right-0 bg-white/80 backdrop-blur-md border-b border-gray-200 z-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4 flex items-center justify-between">
          <div className="flex items-center gap-4">
            {/* KLD Logo */}
            <div className="w-10 h-10 rounded-full flex items-center justify-center">
              <span className="rounded-full overflow-hidden">
                <img
              src="/images/kldlogo.png" alt="KLD Logo"
              className="w-full object-cover"/></span>
            </div>
            <div className="hidden sm:block border-l border-gray-300 h-8"></div>
            {/* STEP Logo */}
            <div className="flex items-center gap-2">
              {/* <div className="w-10 h-10 bg-[#2563EB] rounded-xl flex items-center justify-center">
                <span className="text-white text-lg">S</span>
              </div>
              <span className="text-xl text-[#2563EB]">STEP</span> */}
              <div className="w-16 flex items-center justify-center">
                <img
              src="/images/logostep_dark.png" alt="STEP Logo"
              className="w-full object-cover"/>
              </div>
              
            </div>
          </div>
            <div className="flex items-center gap-3">
              <a
                href="/login"
                className="text-gray-700 hover:text-[#2563EB] hover:bg-blue-50 px-4 py-2 rounded-xl"
              >
                Login
              </a>
              <a
                href="/register"
                className="bg-[#2563EB] hover:bg-blue-700 text-white px-4 py-2 rounded-xl"
                style={{background: "linear-gradient(90deg, #2563EA 0%, #1E3A8A 100%)"}}
              >
                Register
              </a>
            </div>
        </div>
      </nav>

      {/* Hero Section
            <section
        className="relative pt-32 pb-20 px-4 sm:px-6 lg:px-8 text-center bg-cover bg-center"
        style={{ backgroundImage: "url('/images/kld-hero.jpg')" }}
      >
      
        <div className="absolute inset-0 bg-[rgba(239,246,255,0.45)]" />
      
      */}
      <section className="relative pt-32 pb-20 px-4 sm:px-6 lg:px-8 text-center bg-cover bg-center"
        style={{ backgroundImage: "url('/images/kldbg.png')" }}>
        <div className="max-w-4xl mx-auto">
          <div className="inline-flex items-center gap-2 px-4 py-2 bg-blue-100 text-[#2563EB] rounded-full text-sm mb-6">
            <Sparkles className="w-4 h-4" />
            <span>Kolehiyo ng Lungsod ng Dasmariñas</span>
          </div>

          <h1 className="text-5xl sm:text-6xl lg:text-7xl text-gray-900 mb-6">
            KLD School Transparency<br />
            & Engagement Portal
          </h1>

          <p className="text-xl text-gray-600 mb-4 max-w-2xl mx-auto">
            Promoting accountability and transparent student governance at KLD College.
          </p>
          <p className="text-lg text-gray-500 mb-10 max-w-2xl mx-auto">
            A digital transparency ledger system ensuring financial integrity and 
            verifiable records for the KLD Student Council.
          </p>

          {/* <div className="flex flex-col sm:flex-row items-center justify-center gap-4">
            <button
              onClick={navigateToRegister}
              className="bg-[#2563EB] hover:bg-blue-700 text-white px-8 py-6 text-lg rounded-xl w-full sm:w-auto flex items-center justify-center gap-2"
            >
              Get Started <ArrowRight className="w-5 h-5" />
            </button>
            <button
              onClick={navigateToLogin}
              className="border-2 border-[#2563EB] text-[#2563EB] hover:bg-blue-50 px-8 py-6 text-lg rounded-xl w-full sm:w-auto"
            >
              Login to Your Account
            </button>
          </div> */}

          <div className="flex flex-col sm:flex-row items-center justify-center gap-4">
            <button
              onClick={scrollToHowItWorks}
              className="bg-[#2563EB] hover:bg-blue-700 text-white px-6 py-3 text-base rounded-xl flex items-center justify-center gap-2"
              style={{background: "linear-gradient(90deg, #2563EA 0%, #1E3A8A 100%)"}}
            >
              Get Started <ArrowRight className="w-5 h-5" />
            </button>
            {/* <Link
              href={route('login')}
              className="border-2 border-[#2563EB] text-[#2563EB] hover:bg-blue-50 px-6 py-3 text-base rounded-xl flex items-center justify-center gap-2"
            >
              Login to Your Account
            </Link> */}
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section className="py-20 px-4 sm:px-6 lg:px-8 bg-white">
        <div className="max-w-7xl mx-auto">
          <div className="text-center mb-16">
            <h2 className="text-4xl text-gray-900 mb-4">Powerful Features for Transparency</h2>
            <p className="text-xl text-gray-600">Everything you need for accountable student governance</p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {/* Feature 1 */}
            <div className="p-8 rounded-[20px] shadow-lg hover:shadow-xl transition-shadow bg-white">
              <div className="w-16 h-16 bg-blue-100 rounded-xl flex items-center justify-center mb-6">
                <Shield className="w-8 h-8 text-[#2563EB]" />
              </div>
              <h3 className="text-xl text-gray-900 mb-3">Immutable Ledger</h3>
              <p className="text-gray-600 leading-relaxed">
                Every transaction is permanently recorded with SHA256 hashing. 
                No edits, no deletions—only verifiable truth with complete audit trails.
              </p>
            </div>

            {/* Feature 2 */}
            <div className="p-8 rounded-[20px] shadow-lg hover:shadow-xl transition-shadow bg-white">
              <div className="w-16 h-16 bg-green-100 rounded-xl flex items-center justify-center mb-6">
                <FileCheck className="w-8 h-8 text-green-600" />
              </div>
              <h3 className="text-xl text-gray-900 mb-3">Verifiable Proof Upload</h3>
              <p className="text-gray-600 leading-relaxed">
                Upload receipts, documents, and evidence for every transaction. 
                All files are cryptographically verified for authenticity and integrity.
              </p>
            </div>

            {/* Feature 3 */}
            <div className="p-8 rounded-[20px] shadow-lg hover:shadow-xl transition-shadow bg-white">
              <div className="w-16 h-16 bg-purple-100 rounded-xl flex items-center justify-center mb-6">
                <Users className="w-8 h-8 text-purple-600" />
              </div>
              <h3 className="text-xl text-gray-900 mb-3">Student Engagement & Ratings</h3>
              <p className="text-gray-600 leading-relaxed">
                Gamified engagement system with points, badges, and leaderboards. 
                Students rate projects and provide real-time feedback.
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* How It Works Section */}
      <section ref={howItWorksRef} className="py-20 px-4 sm:px-6 lg:px-8">
        <div className="max-w-7xl mx-auto">
          <div className="text-center mb-16">
            <h2 className="text-4xl text-gray-900 mb-4">How It Works</h2>
            <p className="text-xl text-gray-600">Three simple steps to transparent governance</p>
          </div>



          <div className="grid grid-cols-1 md:grid-cols-3 gap-12 lg:mb-16 mb-12">
            {/* Step 1 */}
            <div className="text-center">
              <div className="relative mb-6">
                <div className="w-20 h-20 bg-[#2563EB] rounded-full flex items-center justify-center mx-auto">
                  <span className="text-3xl text-white">1</span>
                </div>
                <div className="absolute top-10 left-1/2 w-full h-0.5 bg-gray-200 hidden md:block -z-10"></div>
              </div>
              <h3 className="text-xl text-gray-900 mb-3">Create Project</h3>
              <p className="text-gray-600">
                CSG Officers create projects with budgets, timelines, and objectives. 
                All details are transparent from day one.
              </p>
            </div>

            {/* Step 2 */}
            <div className="text-center">
              <div className="relative mb-6">
                <div className="w-20 h-20 bg-[#2563EB] rounded-full flex items-center justify-center mx-auto">
                  <span className="text-3xl text-white">2</span>
                </div>
                <div className="absolute top-10 left-1/2 w-full h-0.5 bg-gray-200 hidden md:block -z-10"></div>
              </div>
              <h3 className="text-xl text-gray-900 mb-3">Record Transactions</h3>
              <p className="text-gray-600">
                Every income and expense is logged in the immutable ledger 
                with proof uploads and cryptographic verification.
              </p>
            </div>

            {/* Step 3 */}
            <div className="text-center">
              <div className="relative mb-6">
                <div className="w-20 h-20 bg-[#2563EB] rounded-full flex items-center justify-center mx-auto">
                  <span className="text-3xl text-white">3</span>
                </div>
              </div>
              <h3 className="text-xl text-gray-900 mb-3">Adviser Verification</h3>
              <p className="text-gray-600">
                Advisers review and approve all entries. Students can track 
                approval status and engage with verified data.
              </p>
            </div>
          </div>

          {/* Video Tutorial Section */}
          

          <div className="w-full flex  justify-center align-center">
              <div className="rounded-[20px] overflow-hidden shadow-xl lg:w-[calc(100vw-300px)] w-full">
            {!isVideoPlaying ? (
              <div className="relative animated-gradient w-full aspect-video flex items-center justify-center cursor-pointer" onClick={playVideo}>
                <div className="absolute inset-0 bg-black/20"></div>
                <div className="relative z-10 text-center flex flex-col items-center">
                  <button className="lg:w-20 lg:h-20 w-14 h-14 bg-white rounded-full flex items-center justify-center hover:scale-110 transition-transform shadow-lg">
                    <Play className="lg:w-8 lg:h-8 w-5 h-5 text-blue-600 ml-1" />
                  </button>
                  <p className="text-white text-lg mt-4">Watch STEP Tutorial</p>
                </div>
              </div>
            ) : (
              <video
                ref={videoRef}
                src="/videos/tutorial.mp4"
                controls
                className="w-full h-full fade-in"
                autoPlay
              />
            )}
          </div>
          </div>



        </div>
      </section>

      {/* KLD College Mission Section */}
      <section className="py-20 px-4 sm:px-6 lg:px-8 bg-gradient-to-br from-blue-600 to-blue-800">
        <div className="max-w-7xl mx-auto">
          <div className="text-center max-w-3xl mx-auto text-white">
            <h2 className="text-4xl mb-6">Our Commitment to Transparency</h2>
            <p className="text-xl text-blue-100 mb-6 leading-relaxed">
              At Kolehiyo ng Lungsod ng Dasmariñas, we believe in fostering a culture of 
              accountability and trust. STEP ensures every student can verify how their 
              student council manages funds and executes projects.
            </p>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mt-12">
              <div className="p-6 bg-white/10 backdrop-blur-sm rounded-[20px] border border-white/20">
                <div className="text-3xl mb-3 w-10 flex justify-center mx-auto">
                  <img
              src="/images/Academic.png" alt="Academic"
              className="w-full object-cover"/>
                </div>
                <h3 className="text-lg mb-2">Academic Excellence</h3>
                <p className="text-sm text-blue-100">
                  Supporting student development through transparent governance
                </p>
              </div>
              <div className="p-6 bg-white/10 backdrop-blur-sm rounded-[20px] border border-white/20">
                <div className="text-3xl mb-3 w-10 flex justify-center mx-auto">
                  <img
              src="/images/Financial.png" alt="Financial"
              className="w-full object-cover"/>
              </div>
                <h3 className="text-lg mb-2">Financial Integrity</h3>
                <p className="text-sm text-blue-100">
                  Every peso tracked, verified, and publicly accessible
                </p>
              </div>
              <div className="p-6 bg-white/10 backdrop-blur-sm rounded-[20px] border border-white/20">
                <div className="text-3xl mb-3 w-10 mx-auto">
                  <img
              src="/images/Engagement.png" alt="Engagement"
              className="w-full object-cover"/>
                </div>
                <h3 className="text-lg mb-2">Student Engagement</h3>
                <p className="text-sm text-blue-100">
                  Empowering students to participate in governance decisions
                </p>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-20 px-4 sm:px-6 lg:px-8 bg-gradient-to-br from-[#2563EB] to-blue-700">
        <div className="max-w-4xl mx-auto text-center">
          <h2 className="text-4xl text-white mb-6">
            Ready to Transform Your Student Governance?
          </h2>
          <p className="text-xl text-blue-100 mb-10">
            Join schools already using STEP for transparent, accountable, and engaging student councils.
          </p>
          <a
            href="/register"
            className="bg-white text-[#2563EB] hover:bg-gray-100 px-6 py-3 text-base rounded-xl flex items-center justify-center gap-2 mx-auto w-fit"
          >
            Create Your Account <ArrowRight className="w-5 h-5" />
          </a>

        </div>
      </section>

      {/* Footer */}
      <footer className="py-12 px-4 sm:px-6 lg:px-8 bg-gray-900 text-white">
        <div className="max-w-7xl mx-auto">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-8 mb-8">
            <div>
              <div className="flex items-center gap-3 mb-4">
                <div className="w-16 flex items-center justify-center">
                <img
              src="/images/logostep_light.png" alt="STEP Logo"
              className="w-full object-cover"/>
              </div>
              </div>
              <p className="text-gray-400 text-sm">
                School Transparency & Engagement Portal
              </p>
            </div>

            <div>
              <h4 className="text-sm mb-4">KLD College</h4>
              <ul className="space-y-2 text-sm text-gray-400">
                <li><a href="https://kld.edu.ph" target="_blank" rel="noopener noreferrer" className="hover:text-white transition-colors">Official Website</a></li>
                <li><a href="#" className="hover:text-white transition-colors">About KLD</a></li>
                <li><a href="#" className="hover:text-white transition-colors">Student Council</a></li>
              </ul>
            </div>

            <div>
              <h4 className="text-sm mb-4">STEP Platform</h4>
              <ul className="space-y-2 text-sm text-gray-400">
                <li><a href="#" className="hover:text-white transition-colors">Features</a></li>
                <li><a href="#" className="hover:text-white transition-colors">How It Works</a></li>
                <li><a href="#" className="hover:text-white transition-colors">User Guide</a></li>
              </ul>
            </div>

            <div>
              <h4 className="text-sm mb-4">Contact & Legal</h4>
              <ul className="space-y-2 text-sm text-gray-400">
                <li><a href="#" className="hover:text-white transition-colors">Contact Us</a></li>
                <li><a href="#" className="hover:text-white transition-colors">Privacy Policy</a></li>
                <li><a href="#" className="hover:text-white transition-colors">Terms of Service</a></li>
              </ul>
            </div>
          </div>

          <div className="pt-8 border-t border-gray-800 flex flex-col md:flex-row items-center justify-between">
            <p className="text-sm text-gray-400">© 2026 Kolehiyo ng Lungsod ng Dasmariñas. All rights reserved.</p>
            <div className="flex items-center gap-2 text-sm text-gray-400 mt-4 md:mt-0">
              <CheckCircle className="w-4 h-4 text-green-500" />
              <span>Powered by blockchain-inspired transparency</span>
            </div>
          </div>
        </div>
      </footer>
    </div>
  );
}