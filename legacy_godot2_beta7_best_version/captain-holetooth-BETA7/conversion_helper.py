import os
import re


def main():
    # Define the root directory (current directory where script is located)
    root_dir = os.path.dirname(os.path.abspath(__file__))

    print(f"Scanning for .gd files in {root_dir}...")

    # List of regex replacements
    # (Pattern, Replacement)
    replacements = [
        # Node2D Transform methods (Godot 2 -> Godot 3)
        (r"\bget_pos\(\)", "get_position()"),
        (r"\bset_pos\(", "set_position("),
        (r"\bget_global_pos\(\)", "get_global_position()"),
        (r"\bset_global_pos\(", "set_global_position("),
        (r"\bget_rot\(\)", "get_rotation()"),
        (r"\bset_rot\(", "set_rotation("),
        (r"\bget_global_rot\(\)", "get_global_rotation()"),
        (r"\bset_global_rot\(", "set_global_rotation("),
        # Node methods
        (
            r"\bget_name\(\)",
            "get_name()",
        ),  # Often converted to .name prop, but method exists
        # set_name is mostly same
        # Physics / RigidBody
        # set_linear_velocity exists in Godot 3
        # Lifecycle
        (r"\bfunc _fixed_process\(", "func _physics_process("),
        # Types
        (r"\bMatrix32\b", "Transform2D"),
        (r"\bVector2Array\b", "PoolVector2Array"),
        (r"\bStringArray\b", "PoolStringArray"),
        (r"\bIntArray\b", "PoolIntArray"),
        (r"\bRealArray\b", "PoolRealArray"),
        (r"\bColorArray\b", "PoolColorArray"),
        # Servers & Singletons
        (r"\bPS2D\b", "Physics2DServer"),
        (r"\bGlobals\.get\b", "ProjectSettings.get_setting"),
        (r"\bGlobals\.has\b", "ProjectSettings.has_setting"),
        (r"\bGlobals\.has_singleton\b", "Engine.has_singleton"),
        (r"\bGlobals\.get_singleton\b", "Engine.get_singleton"),
        # JSON Handling
        # Godot 2: dict.parse_json(json_str) -> Godot 3: dict = parse_json(json_str)
        # This regex attempts to catch "var.parse_json(arg)"
        (r"(\w+)\.parse_json\(([^)]+)\)", r"\1 = parse_json(\2)"),
        # Godot 2: dict.to_json() -> Godot 3: to_json(dict)
        (r"(\w+)\.to_json\(\)", r"to_json(\1)"),
        # Opacity -> Modulate alpha
        # Note: This is a rough approximation. Godot 3 uses modulate.a
        (r"\bset_opacity\(([^)]+)\)", r"modulate.a = \1"),
        (r"\bget_opacity\(\)", "modulate.a"),
    ]

    count = 0
    for dirpath, _, filenames in os.walk(root_dir):
        for filename in filenames:
            if filename.endswith(".gd"):
                filepath = os.path.join(dirpath, filename)
                process_file(filepath, replacements)
                count += 1

    print(f"Processed {count} files.")


def process_file(filepath, replacements):
    try:
        with open(filepath, "r", encoding="utf-8") as f:
            content = f.read()
    except Exception as e:
        print(f"Error reading {filepath}: {e}")
        return

    original_content = content

    for pattern, replacement in replacements:
        content = re.sub(pattern, replacement, content)

    if content != original_content:
        print(f"Updating {filepath}")
        try:
            with open(filepath, "w", encoding="utf-8") as f:
                f.write(content)
        except Exception as e:
            print(f"Error writing {filepath}: {e}")


if __name__ == "__main__":
    main()
