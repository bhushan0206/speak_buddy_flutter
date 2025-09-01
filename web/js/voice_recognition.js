// Web Speech API implementation for Flutter web
// This file provides basic Web Speech API support

console.log('Voice recognition JS loaded');

// Check if Web Speech API is available
function isWebSpeechAvailable() {
  return 'webkitSpeechRecognition' in window || 'SpeechRecognition' in window;
}

// Log availability status
if (isWebSpeechAvailable()) {
  console.log('✅ Web Speech API is available');
} else {
  console.log('❌ Web Speech API not supported in this browser');
}
