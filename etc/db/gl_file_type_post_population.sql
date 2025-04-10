update file_type set class = 'Image' where suffix in(
	'.jpg',
	'.jpeg',
	'.png',
	'.gif',
	'.webp'
);
update file_type set class = 'Raw 3D Asset' where suffix in(
	'.obj', 
	'.stl'
);

update file_type set class = 'Raw 2D Asset' where suffix in(
	'.psd'
);

update file_type set class = 'Archive' where suffix in(
	'.zip',
	'.gz',
	'.7z',
	'.rar',
);

update file_type set class = 'Slicer Asset' where suffix in( 
	'.chitubox', 
	'.lys',
	'.photon'
);

update file_type set class = 'Document' where suffix in( 
	'.pdf', 
	'.lys'
);
