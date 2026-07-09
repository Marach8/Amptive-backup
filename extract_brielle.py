import wave
import struct
import math

def calculate_envelope(wav_file, chunk_ms=50):
    with wave.open(wav_file, 'rb') as wf:
        n_channels = wf.getnchannels()
        sample_width = wf.getsampwidth()
        framerate = wf.getframerate()
        n_frames = wf.getnframes()
        
        frames_per_chunk = int(framerate * (chunk_ms / 1000.0))
        envelope = []
        raw_data = wf.readframes(n_frames)
        total_chunks = len(raw_data) // (frames_per_chunk * sample_width * n_channels)
        
        for i in range(total_chunks):
            start = i * frames_per_chunk * sample_width * n_channels
            end = start + (frames_per_chunk * sample_width * n_channels)
            chunk_data = raw_data[start:end]
            
            format_str = f"<{len(chunk_data)//2}h"
            samples = struct.unpack(format_str, chunk_data)
            
            sum_squares = sum([s*s for s in samples])
            rms = math.sqrt(sum_squares / len(samples)) if len(samples) > 0 else 0
            envelope.append(rms)
            
        max_rms = max(envelope) if len(envelope) > 0 else 1
        normalized = [min(1.0, e / max_rms) for e in envelope]
        
        visual_envelope = []
        for n in normalized:
            if n < 0.05:
                val = 1.0
            else:
                val = 1.0 + (math.pow(n, 0.7) * 0.6) 
            visual_envelope.append(round(val, 3))
            
        return visual_envelope

env = calculate_envelope('temp_brielle.wav', chunk_ms=50)

with open('lib/src/features/onboarding/presentation/widgets/audio_envelope.dart', 'a') as f:
    f.write('\nconst List<double> brielleVoiceEnvelope = [\n')
    f.write('  ' + ', '.join(map(str, env)) + '\n')
    f.write('];\n')

print("Appended brielleVoiceEnvelope to audio_envelope.dart with", len(env), "frames!")
