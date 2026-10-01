import Link from "next/link";

export default function Home() {
  return (
    <>
      <h1 className="title">Trial Tmp App</h1>
      <p>
        <Link href="/check-ssr">Check SSR</Link>
      </p>
      <p>
        <Link href="/check-api">Check API</Link>
      </p>
    </>
  );
}
