import { useEffect, useState } from 'react';
import { BookOpen, X } from 'lucide-react';
import { createPortal } from 'react-dom';
import { usePage } from '@inertiajs/react';

const tutorials = {
	csg: { title: 'CSG Officer Tutorial', video: '/videos/COUNCIL_TUTORIAL.mp4' },
	adviser: { title: 'Adviser Tutorial', video: '/videos/ADVISER_TUTORIAL.mp4' },
	sadmin: { title: 'Super Admin Tutorial', video: '/videos/MEMBER_TUTORIAL.mp4' },
	member: { title: 'STEP Tutorial', video: '/videos/MEMBER_TUTORIAL.mp4' },
};

function normalizeRole(role) {
	if (!role) return '';
	return String(role).toLowerCase().replace(/\s+/g, '').replace(/[-_]+/g, '');
}

function getTutorial(role = '', path = '') {
	const normalizedRole = normalizeRole(role);
	const normalizedPath = (path || '').toLowerCase();

	if (normalizedPath.startsWith('/csg') || normalizedRole === 'csg' || normalizedRole === 'csgofficer') {
		return tutorials.csg;
	}

	if (normalizedPath.startsWith('/adviser') || normalizedPath.startsWith('/admin') || normalizedRole === 'adviser' || normalizedRole === 'admin' || normalizedRole === 'adminsadu') {
		return tutorials.adviser;
	}

	if (normalizedPath.startsWith('/sadmin') || normalizedRole === 'sadmin' || normalizedRole === 'superadmin' || normalizedRole === 'superadminuser') {
		return tutorials.sadmin;
	}

	if (normalizedPath.startsWith('/user') || normalizedPath.startsWith('/student') || normalizedPath.startsWith('/member') || normalizedRole === 'student' || normalizedRole === 'member') {
		return tutorials.member;
	}

	return tutorials.member;
}

export default function TutorialButton() {
	const { props } = usePage();
	const userRole = props?.auth?.user?.role?.slug || props?.auth?.user?.role?.name || '';
	const path = typeof window === 'undefined' ? '' : window.location.pathname;
	const isSuperAdmin = normalizeRole(userRole) === 'superadmin' || normalizeRole(userRole) === 'sadmin' || path.startsWith('/sadmin');
	const [isOpen, setIsOpen] = useState(false);
	const [tutorial, setTutorial] = useState(() => getTutorial(userRole, path));

	if (isSuperAdmin) {
		return null;
	}

	useEffect(() => {
		if (!isOpen) return undefined;
		const handleKeyDown = (event) => {
			if (event.key === 'Escape') setIsOpen(false);
		};
		window.addEventListener('keydown', handleKeyDown);
		return () => window.removeEventListener('keydown', handleKeyDown);
	}, [isOpen]);

	useEffect(() => {
		const path = typeof window !== 'undefined' ? window.location.pathname : '';
		setTutorial(getTutorial(userRole, path));
	}, [userRole]);

	const openTutorial = () => {
		const path = typeof window !== 'undefined' ? window.location.pathname : '';
		setTutorial(getTutorial(userRole, path));
		setIsOpen(true);
	};

	const buttonPosition = path.startsWith('/csg') || path.startsWith('/adviser') || path.startsWith('/sadmin')
		? 'bottom-6'
		: 'bottom-20';

	const modal = isOpen && typeof document !== 'undefined' ? createPortal(
		<div
			className="fixed inset-0 z-[1100] flex items-center justify-center bg-gray-950/60 p-4"
			onMouseDown={(event) => {
				if (event.target === event.currentTarget) setIsOpen(false);
			}}
		>
			<section
				role="dialog"
				aria-modal="true"
				aria-labelledby="step-tutorial-title"
				className="w-full max-w-4xl overflow-hidden rounded-2xl bg-white shadow-2xl"
			>
				<header className="flex items-center justify-between gap-4 border-b border-gray-100 px-5 py-4 sm:px-6">
					<h2 id="step-tutorial-title" className="text-lg font-semibold text-gray-900">{tutorial.title}</h2>
					<button
						type="button"
						onClick={() => setIsOpen(false)}
						className="rounded-lg p-2 text-gray-500 transition hover:bg-gray-100 hover:text-gray-800"
						aria-label="Close tutorial"
					>
						<X className="h-5 w-5" />
					</button>
				</header>
				<div className="p-4 sm:p-6">
					<video
						key={tutorial.video}
						src={tutorial.video}
						controls
						autoPlay
						playsInline
						className="aspect-video w-full rounded-xl bg-gray-950"
					/>
				</div>
			</section>
		</div>,
		document.body
	) : null;

	return (
		<>
			<button
				type="button"
				onClick={openTutorial}
				title="Open STEP tutorial"
				aria-label="Open STEP tutorial"
				className={`fixed ${buttonPosition} right-6 z-[1000] flex h-12 w-12 items-center justify-center rounded-full bg-blue-700 text-white shadow-lg transition hover:scale-105 hover:bg-blue-800 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2`}
			>
				<BookOpen className="h-5 w-5" />
			</button>
			{modal}
		</>
	);
}
