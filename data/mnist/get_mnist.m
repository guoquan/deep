% download mnist data-set from http://yann.lecun.com/exdb/mnist/

% train-images-idx3-ubyte.gz:  training set images (9912422 bytes) 
% train-labels-idx1-ubyte.gz:  training set labels (28881 bytes) 
% t10k-images-idx3-ubyte.gz:   test set images (1648877 bytes) 
% t10k-labels-idx1-ubyte.gz:   test set labels (4542 bytes)

base = 'http://yann.lecun.com/exdb/mnist';
files = {'train-images-idx3-ubyte'
    'train-labels-idx1-ubyte'
    't10k-images-idx3-ubyte'
    't10k-labels-idx1-ubyte'};

for idx = 1:numel(files)
    if exist([files{idx} '.gz'], 'file')
        logi(['Already exist ' files{idx} '.gz.']);
    else
        logi(['Download ' files{idx} '.gz.']);
        [~, status] = urlwrite([base '/' files{idx}], files{idx});
        if status ~= 1
            logw(['Failed to download ' files{idx} '.']);
            continue;
        end
    end
    if exist(files{idx}, 'file')
        logi(['Already exist ' files{idx} '.']);
    else
        logi(['Extracted ' files{idx} '.']);
        filenames = gunzip(files{idx});
        if isempty(filenames)
            logw(['Failed to download ' files{idx} '.']);
            continue;
        end
    end
    if exist([files{idx} '.mat'], 'file')
        logi(['Already exist ' files{idx} '.mat.']);
    else
        logi(['Convert ' files{idx} '.mat.']);
        fin = fopen(files{idx}, 'r');
        magic = fread(fin, 1, 'int32', 0, 'b');
        num = fread(fin, 1, 'int32', 0, 'b');
        switch magic
            case 2051
                rows = fread(fin, 1, 'int32', 0, 'b');
                cols = fread(fin, 1, 'int32', 0, 'b');
            case 2049
                rows = 1;
                cols = 1;
            otherwise
                logw(['Unexpected magic number ' num2str(magic) '.']);
                fclose(fin);
                continue;
        end
        data = uint8(zeros(rows * cols, num));
        for sample_idx = 1:num
            % need to transpose each sample (matlab is column first!)
            data(:, sample_idx) = reshape(fread(fin, [cols rows], 'uint8')', 1, []);
        end
        fclose(fin);
        save([files{idx} '.mat'], 'data');
    end
end

