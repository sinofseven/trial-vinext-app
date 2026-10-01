import Link from "next/link";

export default function CheckSsr() {
  return (
    <>
      <h1 className="title">Check SSR</h1>
      <p>
        <Link href="/">戻る</Link>
      </p>
      <hr />
      <p>{process.env.ABOUT_MESSAGE}</p>
    </>
  );
}
