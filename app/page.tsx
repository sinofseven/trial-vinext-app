import Link from "next/link";

export default function Home() {
  return (
    <>
      <h1 className="title">Trial Tmp App</h1>
      <p>
        <Link href="/about">about</Link>
      </p>
    </>
  );
}
