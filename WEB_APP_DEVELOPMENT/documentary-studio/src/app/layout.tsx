import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Documentary Studio - Hidden Nature",
  description: "Create Netflix-quality documentaries with AI assistance",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.Node;
}>) {
  return (
    <html lang="en">
      <body className="antialiased">
        {children}
      </body>
    </html>
  );
}

