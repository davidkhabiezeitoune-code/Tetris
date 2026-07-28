// Cloudflare Worker: relays requests from the sleep tracker app to Anthropic's
// API. Browsers can't call api.anthropic.com directly (it doesn't return CORS
// headers for arbitrary origins), so this thin, stateless pass-through sits in
// between — it reads the caller's API key from each request and forwards it
// straight to Anthropic, without ever storing or logging it.
export default {
  async fetch(request) {
    const cors = {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "POST, OPTIONS",
      "Access-Control-Allow-Headers": "content-type, x-api-key"
    };

    if (request.method === "OPTIONS") {
      return new Response(null, { headers: cors });
    }
    if (request.method !== "POST") {
      return new Response(JSON.stringify({ error: { message: "Method not allowed" } }), {
        status: 405,
        headers: { ...cors, "content-type": "application/json" }
      });
    }

    const apiKey = request.headers.get("x-api-key");
    if (!apiKey) {
      return new Response(JSON.stringify({ error: { message: "Missing x-api-key header" } }), {
        status: 400,
        headers: { ...cors, "content-type": "application/json" }
      });
    }

    const body = await request.text();
    const upstream = await fetch("https://api.anthropic.com/v1/messages", {
      method: "POST",
      headers: {
        "content-type": "application/json",
        "x-api-key": apiKey,
        "anthropic-version": "2023-06-01"
      },
      body
    });

    const responseBody = await upstream.text();
    return new Response(responseBody, {
      status: upstream.status,
      headers: { ...cors, "content-type": "application/json" }
    });
  }
};
