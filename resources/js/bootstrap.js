import axios from 'axios';
window.axios = axios;

window.axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';

// Intercept Inertia "invalid" responses (non-Inertia HTML responses) and
// display a friendly in-app overlay for 403s instead of letting Inertia
// show its default iframe modal (which appears during dev).
import { Inertia } from '@inertiajs/inertia';

Inertia.on('invalid', (event) => {
	try {
		const response = event.detail.response;
		if (response && response.status === 403) {
			// prevent Inertia's default behavior (the iframe overlay)
			event.preventDefault();

			// If we've already shown our overlay, don't duplicate
			if (document.getElementById('inertia-403-overlay')) return;

			const overlay = document.createElement('div');
			overlay.id = 'inertia-403-overlay';
			Object.assign(overlay.style, {
				position: 'fixed',
				inset: '0',
				padding: '50px',
				boxSizing: 'border-box',
				backgroundColor: 'rgba(0,0,0,0.6)',
				zIndex: '200000',
				display: 'flex',
				alignItems: 'center',
				justifyContent: 'center',
			});

			overlay.innerHTML = `
				<div style="max-width:900px;width:100%;">
					<div style="background:white;border-radius:12px;overflow:hidden;display:flex;flex-direction:row;">
						<div style="display:none;@media(min-width:768px){display:block;}background:linear-gradient(180deg,#155DFC,#193CB8);color:white;padding:32px;flex:1;">
							<h2 style="font-size:22px;margin:0 0 8px">Access Denied</h2>
							<p style="opacity:0.9;margin:0">You don't have permission to view this page.</p>
						</div>
						<div style="flex:1;padding:32px;">
							<div style="display:flex;flex-direction:column;align-items:center;text-align:center;">
								<div style="width:96px;height:96px;border-radius:9999px;background:#FEF2F2;display:flex;align-items:center;justify-content:center;margin-bottom:16px;">
									<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"36\" height=\"36\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"#B91C1C\" stroke-width=\"1.5\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><path d=\"M12 9v2m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z\"/></svg>
								</div>
								<h3 style="margin:0;font-size:20px;color:#111827;">403 — Forbidden</h3>
								<p style="color:#6B7280;margin-top:8px;">Sorry — you don’t have access to this resource.</p>

								<div style="display:flex;gap:8px;margin-top:16px;">
									<button id="inertia-403-home" style="background:#2563EB;color:white;border:none;padding:10px 16px;border-radius:8px;">Go to Home</button>
									<button id="inertia-403-close" style="background:white;border:1px solid #E5E7EB;padding:10px 16px;border-radius:8px;">Close</button>
								</div>

							</div>
						</div>
					</div>
				</div>
			`;

			document.body.appendChild(overlay);
			document.body.style.overflow = 'hidden';

			document.getElementById('inertia-403-close').addEventListener('click', () => {
				const el = document.getElementById('inertia-403-overlay');
				if (el) el.remove();
				document.body.style.overflow = 'visible';
			});

			document.getElementById('inertia-403-home').addEventListener('click', () => {
				const el = document.getElementById('inertia-403-overlay');
				if (el) el.remove();
				document.body.style.overflow = 'visible';
				Inertia.visit('/');
			});
		}
	} catch (err) {
		// swallow errors here — do not rethrow and break app bootstrapping
		console.error('Error handling Inertia invalid response:', err);
	}
});
