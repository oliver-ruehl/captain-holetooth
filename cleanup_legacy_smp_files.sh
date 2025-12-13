#!/bin/bash
# Script to remove legacy Godot 2.x SMP audio files
# These have been replaced by OGG format which is compatible with Godot 3.x and 4.x

echo "Cleaning up legacy SMP audio files..."
echo ""

# Count files before
echo "Before cleanup:"
find . -name "*.smp" -type f | wc -l
echo "files found"
echo ""

# Remove SMP files from main project
echo "Removing SMP files from src/audio/sfx/..."
rm -f src/audio/sfx/*.smp

# Remove SMP files from backup/godot3 version
echo "Removing SMP files from godot3-version-new/..."
rm -f godot3-version-new/src/audio/sfx/*.smp
rm -f godot3-version-new/src/objects/torch/*.smp

# Count files after
echo ""
echo "After cleanup:"
remaining=$(find . -name "*.smp" -type f | wc -l)
echo "$remaining files remaining"
echo ""

if [ "$remaining" -eq 0 ]; then
    echo "✅ Cleanup complete! All legacy SMP files have been removed."
    echo "   Audio system now uses OGG format exclusively."
else
    echo "⚠️  Some SMP files remain:"
    find . -name "*.smp" -type f
fi
