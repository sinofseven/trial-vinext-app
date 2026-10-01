import Link from "next/link";

export default function About() {
  return (
    <>
      <h1 className="title">About</h1>
      <p>
        <Link href="/">戻る</Link>
      </p>
      <hr />
      <p>{process.env.ABOUT_MESSAGE}</p>
    </>
  );
}
