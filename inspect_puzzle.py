import os
import struct
import sys

# IMA ADPCM State and Tables for quick decode check
STEP_TABLE = [
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    16,
    17,
    19,
    21,
    23,
    25,
    28,
    31,
    34,
    37,
    41,
    45,
    50,
    55,
    60,
    66,
    73,
    80,
    88,
    97,
    107,
    118,
    130,
    143,
    157,
    173,
    190,
    209,
    230,
    253,
    279,
    307,
    337,
    371,
    408,
    449,
    494,
    544,
    598,
    658,
    724,
    796,
    876,
    963,
    1060,
    1166,
    1282,
    1411,
    1552,
    1707,
    1878,
    2066,
    2272,
    2499,
    2749,
    3024,
    3327,
    3660,
    4026,
    4428,
    4871,
    5358,
    5894,
    6484,
    7132,
    7845,
    8630,
    9493,
    10442,
    11487,
    12635,
    13899,
    15290,
    16818,
    18500,
    20350,
    22385,
    24623,
    27086,
    29794,
    32767,
]

INDEX_TABLE = [-1, -1, -1, -1, 2, 4, 6, 8, -1, -1, -1, -1, 2, 4, 6, 8]


class AdpcmState:
    def __init__(self):
        self.index = 0
        self.predictor = 0


def decode_nibble(nibble, state):
    step = STEP_TABLE[state.index]
    diff = step >> 3
    if nibble & 4:
        diff += step
    if nibble & 2:
        diff += step >> 1
    if nibble & 1:
        diff += step >> 2
    if nibble & 8:
        state.predictor -= diff
    else:
        state.predictor += diff

    if state.predictor > 32767:
        state.predictor = 32767
    elif state.predictor < -32768:
        state.predictor = -32768

    state.index += INDEX_TABLE[nibble]
    if state.index < 0:
        state.index = 0
    elif state.index > 88:
        state.index = 88
    return state.predictor


def print_hex(data, indent="  "):
    hex_str = data.hex()
    for i in range(0, len(hex_str), 32):
        chunk = hex_str[i : i + 32]
        pairs = [chunk[j : j + 2] for j in range(0, len(chunk), 2)]
        print(f"{indent}{' '.join(pairs)}")


def main():
    filepath = "legacy_smp_files/Puzzle_Spell_SkillActivation_Skill_Activation_04.smp"
    if len(sys.argv) > 1:
        filepath = sys.argv[1]

    print(f"Inspecting: {filepath}")
    if not os.path.exists(filepath):
        print("File not found")
        return

    with open(filepath, "rb") as f:
        data = f.read()

    # Find payload
    pattern = b"data\x00\x1f\x00\x00\x00"
    idx = data.find(pattern)
    if idx == -1:
        print("Data block not found")
        return

    start = idx + len(pattern) + 4
    payload = data[start:]

    print(f"Payload size: {len(payload)}")
    print("First 128 bytes of payload (Hex):")
    print_hex(payload[:128])

    # Find first non-zero byte
    nonzero_idx = -1
    for i, b in enumerate(payload):
        if b != 0:
            nonzero_idx = i
            break

    if nonzero_idx == -1:
        print("\nPayload is all zeros.")
        return

    print(f"\nFirst non-zero byte at offset: {nonzero_idx}")
    print("Bytes around start of data:")
    start_view = max(0, nonzero_idx - 16)
    end_view = min(len(payload), nonzero_idx + 64)
    print_hex(payload[start_view:end_view])

    print("\nDecoding entire payload to check for clipping...")
    state_l = AdpcmState()
    state_r = AdpcmState()

    max_val = 0
    clip_count = 0
    total_samples = 0

    # Start from where data actually begins
    for i in range(nonzero_idx, len(payload)):
        b = payload[i]
        low = b & 0x0F
        high = (b >> 4) & 0x0F

        samp_l = decode_nibble(low, state_l)
        samp_r = decode_nibble(high, state_r)

        abs_l = abs(samp_l)
        abs_r = abs(samp_r)

        if abs_l > max_val:
            max_val = abs_l
        if abs_r > max_val:
            max_val = abs_r

        if abs_l >= 32767:
            clip_count += 1
        if abs_r >= 32767:
            clip_count += 1

        total_samples += 2

    print(f"Analysis Complete:")
    print(f"  Total Samples: {total_samples}")
    print(f"  Peak Amplitude: {max_val}")
    print(f"  Clipped Samples: {clip_count} ({clip_count / total_samples * 100:.2f}%)")

    print("\nChecking PCM16 interpretation...")
    pcm_max_val = 0
    pcm_clip_count = 0
    pcm_payload = payload[nonzero_idx:]
    if len(pcm_payload) % 2 != 0:
        pcm_payload = pcm_payload[:-1]

    pcm_count = len(pcm_payload) // 2
    if pcm_count > 0:
        pcm_samples = struct.unpack(f"<{pcm_count}h", pcm_payload)
        for samp in pcm_samples:
            abs_s = abs(samp)
            if abs_s > pcm_max_val:
                pcm_max_val = abs_s
            if abs_s >= 32767:
                pcm_clip_count += 1

        print(f"PCM16 Analysis:")
        print(f"  Total Samples: {pcm_count}")
        print(f"  Peak Amplitude: {pcm_max_val}")
        print(
            f"  Clipped Samples: {pcm_clip_count} ({pcm_clip_count / pcm_count * 100:.2f}%)"
        )


if __name__ == "__main__":
    main()
