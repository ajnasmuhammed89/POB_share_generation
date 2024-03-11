n=1;
for k=1:50
    name=sprintf("name_%d.png",k);
    save1=sprintf("save_%d.png",n);
    save2=sprintf("save_%d.png",n+1);
    share1=imread(name);
    [image_height, image_width] = size(share1);

    block_height = 3;
    block_width = 3;
    table_height = image_height / block_height;
    table_width = image_width / block_width;

    %preallocation
    I_en_hbp=zeros(image_height,image_width);
    I_en_lbp=zeros(image_height,image_width);
    X_k_hbp =zeros(image_height,image_width);
    X_k_lbp =zeros(image_height,image_width);
    I_en_hbp_wat=zeros(image_height,image_width);
    I_en_lbp_wat=zeros(image_height,image_width);

    %calculating Ien
    for i=1:image_height
        for j=1:image_width
            value=share1(i,j);
            Bin_value=dec2bin(value,7);
            Bin_I_en_hbp(i,j)={Bin_value(1:4)};
            Bin_I_en_lbp(i,j)={Bin_value(5:7)};
            I_en_hbp(i,j)=bin2dec(Bin_I_en_hbp(i,j));
            I_en_lbp(i,j)=bin2dec(Bin_I_en_lbp(i,j));
        end
    end

    for i=1:image_height
        for j=1:image_width
            final_I_en_hbp(i,j)=strcat(Bin_I_en_hbp(i,j),'000');
            final_I_en_lbp(i,j)=strcat(Bin_I_en_lbp(i,j),'0000');
            I_en_hbp(i,j)=bin2dec(final_I_en_hbp(i,j));
            I_en_lbp(i,j)=bin2dec(final_I_en_lbp(i,j));
        end
    end
    imwrite(uint8(I_en_hbp),save1);
    imwrite(uint8(I_en_lbp),save2);
    n=n+2;
end