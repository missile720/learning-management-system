import "./globals.css";

export const metadata = {
  title: "Learning Management System",
  description: "LMS focused on programming courses",
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body className="min-h-screen w-full">{children}</body>
    </html>
  );
}