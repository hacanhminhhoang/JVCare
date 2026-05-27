package com.jvcare.util;

import io.github.cdimascio.dotenv.Dotenv;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;

public class GroqAIClient {
    private static final String GROQ_API_URL = "https://api.groq.com/openai/v1/chat/completions";
    private static Dotenv dotenv;
    private static String apiKey;
    private static final Gson gson = new Gson();

    static {
        try {
            dotenv = Dotenv.configure().ignoreIfMissing().load();
            apiKey = dotenv.get("GROQ_API_KEY");
        } catch (Exception e) {
            System.err.println("Could not load .env file. Proceeding with system environment variables if available.");
            dotenv = null;
            apiKey = System.getenv("GROQ_API_KEY");
        }
    }

    public static String getCompletion(String systemPrompt, String userMessage) throws Exception {
        if (apiKey == null || apiKey.isEmpty()) {
            throw new Exception("GROQ_API_KEY is not set.");
        }

        HttpClient client = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(20))
                .build();

        JsonObject requestBody = new JsonObject();
        requestBody.addProperty("model", "llama-3.1-8b-instant");
        
        JsonArray messages = new JsonArray();
        
        JsonObject systemMessage = new JsonObject();
        systemMessage.addProperty("role", "system");
        systemMessage.addProperty("content", systemPrompt);
        messages.add(systemMessage);
        
        JsonObject userMsg = new JsonObject();
        userMsg.addProperty("role", "user");
        userMsg.addProperty("content", userMessage);
        messages.add(userMsg);
        
        requestBody.add("messages", messages);
        requestBody.addProperty("temperature", 0.7);

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(GROQ_API_URL))
                .header("Authorization", "Bearer " + apiKey)
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();

        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

        if (response.statusCode() == 200) {
            JsonObject responseJson = gson.fromJson(response.body(), JsonObject.class);
            return responseJson.getAsJsonArray("choices")
                    .get(0).getAsJsonObject()
                    .getAsJsonObject("message")
                    .get("content").getAsString();
        } else {
            throw new Exception("Error from Groq API: " + response.statusCode() + " " + response.body());
        }
    }
}
