function compress -d "Create a .tar.gz archive from a file or directory"
    if test (count $argv) -eq 0
        echo "Usage: compress <file_or_directory>"
        return 1
    end

    set -l target (string trim --right --chars=/ $argv[1])
    tar -czf "$target.tar.gz" "$target"
end
