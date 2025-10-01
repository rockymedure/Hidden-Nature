import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Documentary Studio",
  description: "Professional documentary production interface with AI-powered scene generation",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className="antialiased">{children}</body>
    </html>
  );
}