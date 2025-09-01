# 🤖 Gemini AI Integration Setup

## Overview
SpeakBuddy now supports Google Gemini AI for content generation. The app is configurable and can switch between different AI providers (Gemini and OpenAI).

## Features
- **Configurable AI Provider**: Switch between Gemini and OpenAI
- **Gemini 1.5 Flash**: Uses the latest Gemini model for optimal performance
- **Fallback System**: Graceful fallback to demo data if AI generation fails
- **Structured Output**: Generates JSON-formatted content for stories, characters, and responses

## Setup Instructions

### 1. Get Gemini API Key
1. Go to [Google AI Studio](https://aistudio.google.com/)
2. Sign in with your Google account
3. Navigate to "Get API key" in the left sidebar
4. Create a new API key or use an existing one
5. Copy the API key (it should start with `AIza...`)

### 2. Configure Environment Variables

#### For Web (Recommended)
Edit `web/index.html` and replace the placeholder:
```javascript
window.flutterEnvironment = {
  AI_PROVIDER: 'gemini',
  GEMINI_API_KEY: 'YOUR_ACTUAL_GEMINI_API_KEY_HERE', // Replace this
  // ... other config
};
```

#### For Mobile (.env file)
Create or update your `.env` file:
```bash
# AI Configuration
AI_PROVIDER=gemini
GEMINI_API_KEY=YOUR_ACTUAL_GEMINI_API_KEY_HERE

# Keep existing Firebase config
FIREBASE_API_KEY=...
FIREBASE_APP_ID=...
# etc.
```

### 3. Switch Between AI Providers

To switch back to OpenAI:
```bash
# In .env file
AI_PROVIDER=openai
OPENAI_API_KEY=your_openai_key

# Or in web/index.html
AI_PROVIDER: 'openai'
```

### 4. Test the Integration
1. Run the app: `flutter run`
2. Navigate to Story Adventure
3. Check the console logs for AI service initialization
4. Try generating content - you should see Gemini logs

## Configuration Options

### AI Provider Settings
- `AI_PROVIDER`: Set to `'gemini'` or `'openai'`
- `GEMINI_API_KEY`: Your Gemini API key
- `OPENAI_API_KEY`: Your OpenAI API key (if switching back)

### Gemini Model Configuration
The app uses Gemini 1.5 Flash with these settings:
- **Model**: `gemini-1.5-flash`
- **Temperature**: 0.7 (balanced creativity)
- **Max Tokens**: 2048
- **Top-K**: 40
- **Top-P**: 0.95

## Troubleshooting

### Common Issues

1. **"Gemini API key not configured"**
   - Check that `GEMINI_API_KEY` is set in your environment
   - Verify the key starts with `AIza...`

2. **"AI_PROVIDER not found"**
   - Ensure `AI_PROVIDER` is set to `'gemini'`
   - Check environment variable loading

3. **Content generation fails**
   - Check console logs for detailed error messages
   - Verify your API key has sufficient quota
   - The app will fallback to demo data automatically

### Debug Logs
The app provides detailed logging:
- `🤖 Initializing Gemini AI Service`
- `🔑 Gemini API Key length: X`
- `🤖 Gemini: Generating content`
- `🤖 Gemini: Response received`

## Benefits of Gemini

1. **Cost Effective**: Generally more affordable than OpenAI
2. **High Quality**: Excellent for creative content generation
3. **Fast Response**: Quick generation times
4. **Google Integration**: Seamless with Google services
5. **Structured Output**: Better JSON formatting for our use case

## Future Enhancements

- Support for additional AI providers
- Model selection (different Gemini models)
- Custom prompt templates
- A/B testing between providers
- Usage analytics and cost tracking

## Security Notes

- Never commit API keys to version control
- Use environment variables for all sensitive data
- Consider using Google Cloud IAM for production
- Monitor API usage and set up alerts

## Support

If you encounter issues:
1. Check the console logs for detailed error messages
2. Verify your API key is valid and has quota
3. Test with a simple prompt first
4. The app includes fallback mechanisms for reliability
