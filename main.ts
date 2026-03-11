const host = Deno.env.get("OVH_HOST")!;
const user = Deno.env.get("OVH_USER")!;
const pass = Deno.env.get("OVH_PASS")!;
const interval = Number(Deno.env.get("INTERVAL") ?? 300000);

const ipFile = "/data/last_ip";

async function getIP(): Promise<string> {
  const res = await fetch("https://api.ipify.org");
  return (await res.text()).trim();
}

async function getLastIP(): Promise<string | null> {
  try {
    return (await Deno.readTextFile(ipFile)).trim();
  } catch {
    return null;
  }
}

async function saveIP(ip: string) {
  await Deno.writeTextFile(ipFile, ip);
}

async function updateDNS(ip: string) {
  const url =
    `https://www.ovh.com/nic/update?system=dyndns&hostname=${host}&myip=${ip}`;

  const auth = btoa(`${user}:${pass}`);

  const res = await fetch(url, {
    headers: {
      Authorization: `Basic ${auth}`,
    },
  });

  console.log("OVH response:", await res.text());
}

async function loop() {
  while (true) {
    try {
      const ip = await getIP();
      const last = await getLastIP();

      if (ip !== last) {
        console.log(`IP changed: ${last} -> ${ip}`);
        await updateDNS(ip);
        await saveIP(ip);
      } else {
        console.log("IP unchanged:", ip);
      }
    } catch (err) {
      console.error("Error:", err);
    }

    await new Promise((r) => setTimeout(r, interval));
  }
}

loop();