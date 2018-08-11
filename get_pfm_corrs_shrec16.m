bases = {'cat','centaur','david','dog','horse','michael','victoria','wolf'};
set = 'cuts'
set_base = 'D:\OneDrive\shrec cuts\shrec2016_PartialDeformableShapes_TestSet\';
mkdir('output');
mkdir('output',set);

for b = 1:8
    base = bases{b}
    files = dir(fullfile(set_base,set,[set '_' base '*_r.off']));        
    M = load_off([set_base 'null\', base ,'.off']); 
    barmap = shape_point_to_barycentric_map(M);
    for i = 1:length(files)
        cut_name = files(i).name(1:end-4)
        cut_file = fullfile(set_base,set,files(i).name);
        N = load_off(cut_file);
        corrs = partial_functional_correspondence(M,N);
        bar = corr_to_bar_matlab(corrs,N,barmap);
        outfile = fullfile('output',set,[files(i).name(1:end-6) '.corr']);
        dlmwrite(outfile,bar,'delimiter','\t');
    end
end


