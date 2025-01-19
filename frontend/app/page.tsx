"use client";
import { useUser } from "@clerk/nextjs";
import {
  SignInButton,
  SignedIn,
  SignedOut,
  UserButton,
} from "@clerk/nextjs";

export default function Home() {
  const {  user } = useUser();

  return (
    <div className="flex flex-col items-center justify-center min-h-screen bg-gradient-to-b from-blue-500 to-purple-600 p-8 text-white font-[family-name:var(--font-geist-sans)]">
      <div className="flex flex-col items-center gap-4 p-10 bg-white/10 backdrop-blur-md rounded-3xl shadow-xl">
        <SignedIn>
          <h1 className="text-3xl font-extrabold tracking-tight text-center">
            Hi, {user?.primaryEmailAddress?.emailAddress || "there"}! 👋
          </h1>
          <p className="text-lg text-center">
            Enjoy your personalized experience!
          </p>
          <UserButton afterSignOutUrl="/" />
        </SignedIn>
        <SignedOut>
          <h1 className="text-3xl font-extrabold tracking-tight text-center">
            Welcome, please sign in! 🚀
          </h1>
          <p className="text-lg text-center">
            Sign in to access all the features.
          </p>
          <SignInButton mode="modal">
            <button className="mt-6 px-6 py-3 rounded-full bg-white text-purple-600 text-lg font-bold shadow-lg hover:bg-purple-600 hover:text-white transition-all">
              Sign In
            </button>
          </SignInButton>
        </SignedOut>
      </div>
    </div>
  );
}
