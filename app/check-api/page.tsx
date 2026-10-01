"use client";
import Link from "next/link";

export default function CheckApi() {
  async function call() {
    const resp = await fetch("/api/hello");
    const data = (await resp.json()) as { message: string };
    alert(data.message);
  }
  return (
    <>
      <h1 className="title">Check API</h1>
      <p>
        <Link href="/">戻る</Link>
      </p>
      <hr />
      <p>
        <button className="button" onClick={call}>
          Call API hello
        </button>
      </p>
    </>
  );
}
