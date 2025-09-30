function decompress -d "Extract a .tar.gz archive"
    if test (count $argv) -eq 0
        echo "Usage: decompress <archive.tar.gz>"
        return 1
    end

    tar -xzf $argv[1]
end
