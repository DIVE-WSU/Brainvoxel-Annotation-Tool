function voxels = getVoxels(region, ontology, annot)

[children,~] = find(ismember(ontology(:,2),num2str(region)));

voxels = [];
for i=1:length(children)
    voxels = [voxels; getVoxels(str2num(char(ontology(children(i),1))), ontology, annot)];
end

mine = find(annot==region);

voxels = [voxels; mine];
