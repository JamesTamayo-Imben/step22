# Google OAuth Setup Checklist

## ✅ Code Implementation Complete
- [x] SupabaseContext.jsx - Added `signInWithGoogle()` and `validateGoogleEmailDomain()`
- [x] Login.jsx - Integrated Google OAuth with email validation
- [x] Register.jsx - Integrated Google OAuth with email validation
- [x] OAuthCallback.jsx - Created redirect handler
- [x] routes/auth.php - Added `/auth/callback` route
- [x] Build successful - No errors

## 📋 Next Steps: Configure Google Cloud & Supabase

### ⭐ Best Option: Create Free Google Cloud Project (No Credit Card!)

You need Google OAuth credentials. **Good news:** Creating a Google Cloud project is **FREE** and **doesn't require a credit card**. Just creating the project and getting credentials is free!

### Step 1: Create Google Cloud Project (FREE)
- [ ] Go to https://console.cloud.google.com/
- [ ] Click **Create a new project**
- [ ] Name it: **STEP School**
- [ ] Click **Create**
- [ ] Wait for project creation (usually 1-2 minutes)

### Step 2: Enable Google+ API
- [ ] In Google Cloud Console, at the top search for: **"Google+ API"**
- [ ] Click on "Google+ API" from results
- [ ] Click the blue **"Enable"** button
- [ ] Wait for it to enable

### Step 3: Create OAuth 2.0 Credentials (FREE)
- [ ] In Google Cloud Console, go to **Credentials** (left sidebar)
- [ ] Click **"Create Credentials"** at the top
- [ ] Select **"OAuth 2.0 Client ID"**
- [ ] When prompted, click **"Create OAuth consent screen"** first

### Step 4: Set Up OAuth Consent Screen (FREE)
- [ ] Choose **External** user type
- [ ] Click **Create**
- [ ] Fill in the form:
  - App name: **STEP**
  - User support email: Your email
  - Developer email: Your email
- [ ] Click **Save and Continue**
- [ ] Skip optional scopes (click **Save and Continue**)
- [ ] Skip test users (click **Save and Continue**)
- [ ] Review and click **Back to Dashboard**

### Step 5: Create OAuth Credentials (FREE)
- [ ] Go back to **Credentials** page
- [ ] Click **Create Credentials** → **OAuth 2.0 Client ID**
- [ ] Select **Web Application**
- [ ] Name it: **STEP Login**
- [ ] Under **Authorized JavaScript origins**, add:
  ```
  http://localhost:5173
  http://127.0.0.1:5173
  ```
- [ ] Under **Authorized redirect URIs**, add:
  ```
  http://localhost:5173/auth/callback
  ```
- [ ] Click **Create**
- [ ] A popup appears with your credentials
- [ ] **Copy the Client ID and Client Secret** (save them somewhere safe)
- [ ] Click **OK**

### Step 6: Add Credentials to Supabase
- [ ] Go to Supabase Dashboard: https://supabase.com/
- [ ] Click on your **STEP** project
- [ ] Go to **Authentication** → **Providers**
- [ ] Click on **Google**
- [ ] Enable Google provider
- [ ] Paste your **Client ID** from Google Cloud
- [ ] Paste your **Client Secret** from Google Cloud
- [ ] Click **Save**

### Step 7: Add Redirect URL to Supabase
- [ ] Still in Authentication settings
- [ ] Go to **"URL Configuration"**
- [ ] Under "Redirect URLs", add:
  ```
  http://localhost:5173/auth/callback
  ```
- [ ] Click **Add URL**
- [ ] Save

### Step 8: Verify Environment Variables
- [ ] In `.env`, check these are set:
  ```
  VITE_SUPABASE_URL=<your_supabase_url>
  VITE_SUPABASE_ANON_KEY=<your_anon_key>
  ```
- [ ] If not set, go to **Supabase** → **Project Settings** → **API** and copy them

✅ **That's all! No credit card needed - just creating the project is free!**

---

## 💡 Why No Credit Card?

- **Creating a Google Cloud project:** 100% FREE
- **Enabling APIs:** 100% FREE  
- **Creating OAuth credentials:** 100% FREE
- **Monthly free tier:** Includes OAuth usage
- **Credit card:** Only needed if you want paid features (you don't)

Google Cloud lets you create and use OAuth completely free!

---

## 🚀 If Google Cloud Asks for Credit Card

Sometimes Google may ask for a credit card to verify your account (anti-fraud). If this happens:
- It's **just verification** - you won't be charged
- **No billing** occurs for free tier services
- You can remove the card after verification
- Skip it if you don't want to - OAuth still works

---

## (Reference) Previous Alternative Steps

If you want to use your own Google OAuth credentials instead of the main steps above:

### Step A: Create Google Cloud Project
- [ ] Go to https://console.cloud.google.com/
- [ ] Create a new project named "STEP School"
- [ ] Wait for project creation

### Step B: Enable Google+ API
- [ ] In Google Cloud Console, search for "Google+ API"
- [ ] Click "Enable"
- [ ] Wait for it to enable

### Step C: Create OAuth Credentials
- [ ] Go to "Credentials" in Google Cloud Console
- [ ] Click "Create Credentials" → "OAuth 2.0 Client ID"
- [ ] Select "Web Application"
- [ ] Under "Authorized JavaScript origins", add:
  ```
  http://localhost:5173
  http://127.0.0.1:5173
  ```
- [ ] Under "Authorized redirect URIs", add:
  ```
  http://localhost:5173/auth/callback
  ```
- [ ] Click "Create"
- [ ] Copy the **Client ID** and **Client Secret**

### Step D: Configure Supabase with Your Credentials
- [ ] Go to Supabase Dashboard
- [ ] Click on your project
- [ ] Go to "Authentication" → "Providers"
- [ ] Click "Google"
- [ ] Enable Google provider
- [ ] Paste Google Client ID in "Client ID"
- [ ] Paste Google Client Secret in "Client Secret"
- [ ] Save

## 🧪 Testing (3 Easy Steps!)

### Test 1: Start Dev Server
- [ ] In terminal, run:
  ```bash
  npm run dev
  ```
- [ ] Wait for "Local: http://localhost:5173"

### Test 2: Login with Valid Email
- [ ] Go to `http://localhost:5173/login`
- [ ] Click "Continue with Google"
- [ ] Sign in with a **@kld.edu.ph** Google account (or any account to test)
- [ ] Check browser console for any errors
- [ ] Should be redirected and authenticated
- [ ] If email is NOT @kld.edu.ph, should see error and redirect to login

### Test 3: Register with Valid Email
- [ ] Go to `http://localhost:5173/register`
- [ ] Click "Continue with Google"
- [ ] Sign in with your Google account
- [ ] Should be redirected and account created
- [ ] If email is NOT @kld.edu.ph, should see error

**That's it! You're ready to test!**

## 🚀 Production Setup

### For Production (e.g., `https://kldstep.com`)

**Using Supabase's Free Google OAuth:**
1. Go to **Supabase** → **Authentication** → **URL Configuration**
2. Add your production URL:
   ```
   https://kldstep.com/auth/callback
   ```
3. Save

**That's it! No Google Cloud setup needed.**

---

**If You Added Your Own Google Cloud Credentials:**
1. Go to **Google Cloud Console**
2. Update "Authorized JavaScript origins":
   ```
   https://kldstep.com
   ```
3. Update "Authorized redirect URIs":
   ```
   https://kldstep.com/auth/callback
   ```
4. Also update in **Supabase** → **Authentication** → **URL Configuration**

## 📝 Useful Links

- [Supabase Google Auth Docs](https://supabase.com/docs/guides/auth/social-login/auth-google)
- [Google Cloud Console](https://console.cloud.google.com/)
- [OAuth 2.0 Tutorial](https://developers.google.com/identity/protocols/oauth2)

## ❓ Common Issues

**Issue:** "Invalid client ID"
- **Solution:** Check Google Cloud credentials match Supabase settings

**Issue:** "Redirect URL mismatch"
- **Solution:** Ensure redirect URLs match exactly in both Google Cloud and Supabase

**Issue:** User not authenticated after callback
- **Solution:** Check browser console for errors, verify Supabase session

**Issue:** Email validation not blocking invalid emails
- **Solution:** Verify `validateGoogleEmailDomain()` is called in OAuthCallback

## 💡 What's Already Done

✅ Google OAuth methods in SupabaseContext  
✅ Login page integrated with Google auth  
✅ Register page integrated with Google auth  
✅ OAuth callback page with email validation  
✅ Route handler for OAuth redirect  
✅ Email domain validation (@kld.edu.ph only)  
✅ Error handling and messages  
✅ Build passing with no errors  

## 📞 Support

If you get stuck:
1. Check browser console for error messages
2. Check Supabase logs for auth errors
3. Verify Google Cloud credentials are correct
4. Clear browser cache and cookies
5. Try in incognito/private browser window

---

**Status:** Ready for Google Cloud setup and testing
**Last Updated:** March 12, 2026
