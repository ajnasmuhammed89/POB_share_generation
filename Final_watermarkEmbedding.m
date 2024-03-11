% Data embedding for watermarking
% clc;
% clear;



share1=imgShare2;
%share1=imresize(share1, [375 390]);
[image_height, image_width] = size(share1);
%update size
image_height = image_height-mod(image_height,3);
image_width = image_width-mod(image_width,3);
share1=share1(1:image_height,1:image_width);
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

%permutation
[I_en_hbp_per,hbp_PermuSeq]=Permu(I_en_hbp);
[I_en_lbp_per,lbp_PermuSeq]=Permu(I_en_lbp);

%calculating x_k
for i=1:image_height
    for j=1:image_width
        if i==1 && j==1
            X_k_hbp(i,j)=bitxor(I_en_hbp(1,2),I_en_hbp(2,1));
            X_k_lbp(i,j)=bitxor(I_en_lbp(1,2),I_en_lbp(2,1));
        elseif i==image_height && j==image_width
            X_k_hbp(i,j)=bitxor(I_en_hbp(i,j-1),I_en_hbp(i-1,j));
            X_k_lbp(i,j)=bitxor(I_en_lbp(i,j-1),I_en_lbp(i-1,j));
        elseif i==1 && j==image_width
            X_k_hbp(i,j)=bitxor(I_en_hbp(1,image_width-1),I_en_hbp(2,image_width));
            X_k_lbp(i,j)=bitxor(I_en_lbp(1,image_width-1),I_en_lbp(2,image_width));
        elseif i==image_height && j==1
            X_k_hbp(i,j)=bitxor(I_en_hbp(image_height-1,1),I_en_hbp(image_height,2));
            X_k_lbp(i,j)=bitxor(I_en_lbp(image_height-1,1),I_en_lbp(image_height,2));
        elseif i~=1 && j==image_width
            X_k_hbp(i,j)=bitxor(I_en_hbp(i,image_width-1),bitxor(I_en_hbp(i-1,image_width),I_en_hbp(i+1,image_width)));
            X_k_lbp(i,j)=bitxor(I_en_lbp(i,image_width-1),bitxor(I_en_lbp(i-1,image_width),I_en_lbp(i+1,image_width)));
        elseif i==image_height && j~=1
            X_k_hbp(i,j)=bitxor(I_en_hbp(image_height-1,j),bitxor(I_en_hbp(image_height,j-1),I_en_hbp(image_height,j+1)));
            X_k_lbp(i,j)=bitxor(I_en_lbp(image_height-1,j),bitxor(I_en_lbp(image_height,j-1),I_en_lbp(image_height,j+1))); 
        elseif i==1 && j~=1 && j~=image_width
            X_k_hbp(i,j)=bitxor(I_en_hbp(i+1,j),bitxor(I_en_hbp(i,j-1),I_en_hbp(i,j+1)));
            X_k_lbp(i,j)=bitxor(I_en_lbp(i+1,j),bitxor(I_en_lbp(i,j-1),I_en_lbp(i,j+1)));
        elseif i~=1 && j==1 && i~=image_height
            X_k_hbp(i,j)=bitxor(I_en_hbp(i,j+1),bitxor(I_en_hbp(i-1,j),I_en_hbp(i+1,j)));
            X_k_lbp(i,j)=bitxor(I_en_lbp(i,j+1),bitxor(I_en_lbp(i-1,j),I_en_lbp(i+1,j)));    
        else
            X_k_hbp(i,j)=bitxor(bitxor(I_en_hbp(i-1,j),I_en_hbp(i+1,j)),bitxor(I_en_hbp(i,j-1),I_en_hbp(i,j+1)));
            X_k_lbp(i,j)=bitxor(bitxor(I_en_lbp(i-1,j),I_en_lbp(i+1,j)),bitxor(I_en_lbp(i,j-1),I_en_lbp(i,j+1)));
        end
    end
end

%Certificate watermark generation

for i=1:image_height
    for j=1:image_width
        bin_Ce_WaterMark_hbp=dec2bin(X_k_hbp(i,j),4);
        bin_Ce_WaterMark_lbp=dec2bin(X_k_lbp(i,j),3);
        ce_wm_hbp(i,j)={bin_Ce_WaterMark_hbp(3:4)};
        ce_wm_lbp(i,j)={bin_Ce_WaterMark_lbp(2:3)};
        bin_Re_WaterMark_hbp=dec2bin(I_en_hbp_per(i,j),4);
        bin_Re_WaterMark_lbp=dec2bin(I_en_lbp_per(i,j),3);
        re_wm_hbp(i,j)={bin_Re_WaterMark_hbp(1:4)};
        re_wm_lbp(i,j)={bin_Re_WaterMark_lbp(1:3)};
    end
end

image_part_hbp=string(zeros(image_height,image_width));
image_part_lbp=string(zeros(image_height,image_width));
ce_watermark_hbp=string(zeros(image_height,image_width));
ce_watermark_lbp=string(zeros(image_height,image_width));
re_watermark_hbp=string(zeros(image_height,image_width));
re_watermark_lbp=string(zeros(image_height,image_width));


%watermarking
for i=1:image_height
    for j=1:image_width
        image_part_hbp(i,j)=dec2bin(I_en_hbp_per(i,j),4);
        image_part_lbp(i,j)=dec2bin(I_en_lbp_per(i,j),3);
        ce_watermark_hbp(i,j)=char(ce_wm_hbp(i,j));
        ce_watermark_lbp(i,j)=char(ce_wm_lbp(i,j));
        re_watermark_hbp(i,j)=dec2bin(I_en_lbp_per(i,j),3);
        re_watermark_lbp(i,j)=dec2bin(I_en_hbp_per(i,j),4);
        wt_final_hbp(i,j)=strcat(image_part_hbp(i,j),ce_watermark_hbp(i,j),re_watermark_hbp(i,j));
        I_en_hbp_per_wat_final(i,j)=bin2dec(wt_final_hbp(i,j));
        wt_final_lbp(i,j)=strcat(image_part_lbp(i,j),ce_watermark_lbp(i,j),re_watermark_lbp(i,j));
        I_en_lbp_per_wat_final(i,j)=bin2dec(wt_final_lbp(i,j));
    end
end

%tampering

tampered_I_en_hbp=I_en_hbp_per_wat_final;
tampered_I_en_lbp=I_en_lbp_per_wat_final;



%recovery
I_recovered_hbp=tampered_I_en_hbp;
I_recovered_lbp=tampered_I_en_lbp;

I_rpob_hbp=I_recovered_hbp;
I_rpob_lbp=I_recovered_lbp;




%extraction of watermarks
for i=1:image_height
    for j=1:image_width
        recovered_binary_rpob_hbp=dec2bin(I_rpob_hbp(i,j),9);
        R_original_msb(i,j)=bin2dec(recovered_binary_rpob_hbp(1:4));
        R_ce_msb(i,j)=bin2dec(recovered_binary_rpob_hbp(5:6));
        R_re_msb(i,j)=bin2dec(recovered_binary_rpob_hbp(7:9));
        recovered_binary_rpob_lbp=dec2bin(I_rpob_lbp(i,j),9);
        R_original_lsb(i,j)=bin2dec(recovered_binary_rpob_lbp(1:3));
        R_ce_lsb(i,j)=bin2dec(recovered_binary_rpob_lbp(4:5));
        R_re_lsb(i,j)=bin2dec(recovered_binary_rpob_lbp(6:9));
    end
end

%inverse permutation
I_R_original_msb=I_permu(R_original_msb,hbp_PermuSeq);
I_R_original_lsb=I_permu(R_original_lsb,lbp_PermuSeq);
%I_R_ce_msb=I_permu(R_ce_msb,hbp_PermuSeq);
%I_R_ce_lsb=I_permu(R_ce_lsb,lbp_PermuSeq);
I_R_re_msb=I_permu(R_re_msb,lbp_PermuSeq);
I_R_re_lsb=I_permu(R_re_lsb,hbp_PermuSeq);




%calculate the CW in blocks
YourImage_ce_msb = im2double(R_ce_msb);
YourImage_ce_lsb = im2double(R_ce_lsb);
[m,n]=size(YourImage_ce_lsb);
CE_MSB_Block = cell(m/3,n/3);
CE_LSB_Block = cell(m/3,n/3);
counti = 0;
for i = 1:3:m-2
   counti = counti + 1;
   countj = 0;
   for j = 1:3:n-2
        countj = countj + 1;
        CE_MSB_Block{counti,countj} = YourImage_ce_msb(i:i+2,j:j+2);
        CE_LSB_Block{counti,countj} = YourImage_ce_lsb(i:i+2,j:j+2);
   end
end



%R_original_msb=I_R_original_msb;
%R_original_lsb=I_R_original_lsb;
%R_re_msb=I_R_re_msb;
%R_re_lsb=I_R_re_lsb;


I_rpob_en_hbp=I_R_original_msb;
I_rpob_en_lbp=I_R_original_lsb;


%Two level comparison
%inputs
for i=1:image_height
    for j=1:image_width
        Le=dec2bin(I_rpob_en_lbp(i,j),3);
        L(i,j)=string(Le);
        Ms=dec2bin(I_rpob_en_hbp(i,j),4);
        M(i,j)=string(Ms);
        O_RW1=dec2bin(R_re_lsb(i,j),4);
        O_R1(i,j)=string(O_RW1);
        O_RW2=dec2bin(R_re_msb(i,j),3);
        O_R2(i,j)=string(O_RW2);
        RW1=dec2bin(I_R_re_lsb(i,j),4);
        R1(i,j)=string(RW1);
        RW2=dec2bin(I_R_re_msb(i,j),3);
        R2(i,j)=string(RW2);
    end
end

%assigning R1 to the base
%R1=string(Bin_I_en_hbp);

%calculate M1
for i=1:image_height
    for j=1:image_width
        %[a,b]=find(lbp_PermuSeq==((j-1)*image_height+i));
        if isequal(M(i,j),R1(i,j))
            M1(i,j)=0;
        %elseif isequal(L(i,j),O_R2(i,j))
            %fprintf("%d %d/n",i,j);
            %M1(i,j)=0;
        else
            M1(i,j)=1;
        end
    end
end

YourImage = im2double(M1);
[m,n] = size(YourImage);
M1Block = cell(m/3,n/3);
counti = 0;
for i = 1:3:m-2
   counti = counti + 1;
   countj = 0;
   for j = 1:3:n-2
        countj = countj + 1;
        M1Block{counti,countj} = YourImage(i:i+2,j:j+2);
   end
end




%calculate M2
for i=1:image_height
    for j=1:image_width
        %[a,b]=find(hbp_PermuSeq==((j-1)*image_height+i));
        if isequal(L(i,j),R2(i,j))
            M2(i,j)=0;
        %elseif isequal(M(i,j),O_R1(i,j))
            %M2(i,j)=0;
        else
            M2(i,j)=1;
        end
    end
end

YourImage = im2double(M2);
[m,n] = size(YourImage);
M2Block = cell(m/3,n/3);
counti = 0;
for i = 1:3:m-2
   counti = counti + 1;
   countj = 0;
   for j = 1:3:n-2
        countj = countj + 1;
        M2Block{counti,countj} = YourImage(i:i+2,j:j+2);
   end
end

for i=1:m/3
    for j=1:n/3
        if all(M1Block{i,j}(:)==0)
            Map1(i,j)=0;
        else
            Map1(i,j)=1;
        end
        if all(M2Block{i,j}(:)==0)
            Map2(i,j)=0;
        else
            Map2(i,j)=1;
        end
    end
end


%block cheking
% k=1;
% l=1;
% for i=1:3:image_height
%     for j=1:3:image_width
%         block=M2(i:i+2,j:j+2);
%         block=reshape(block,[1,9]);
%         for w=1:9
%             if block(w)==1
%                 Map2(k,l)=1;
%                 break;
%             else
%                 Map2(k,l)=0;
%             end
%         end
%         k=k+1;
%         l=l+1;
%     end
% end

M1_new=Map1;
M2_new=Map2;

%Neeigbour based refinement
for i=1:image_height/3
    for j=1:image_width/3
        if i==1 && j==1
            if Map1(1,2)==1 && Map1(2,1)==1
                M1_new(i,j)=1;
            end
            if Map2(1,2)==1 && Map2(2,1)==1
                M2_new(i,j)=1;
            end
        elseif i==image_height/3 && j==image_width/3
            if Map1(i,j-1)==1 && Map1(i-1,j)==1
                M1_new(i,j)=1;
            end
            if Map2(i,j-1)==1 && Map2(i-1,j)==1
                M2_new(i,j)=1;
            end
        elseif i==1 && j==image_width/3
            if Map1(i,j-1)==1 && Map1(i+1,j)==1
                M1_new(i,j)=1;
            end
            if Map2(i,j-1)==1 && Map2(i+1,j)==1
                M2_new(i,j)=1;
            end
        elseif i==image_height/3 && j==1
            if Map1(i-1,j)==1 && Map1(i,j+1)==1
                M1_new(i,j)=1;
            end
            if Map2(i-1,j)==1 && Map2(i,j+1)==1
                M2_new(i,j)=1;
            end
        elseif i~=1 && j==image_width/3
            if Map1(i,j-1)==1 && Map1(i-1,j)==1 && Map1(i+1,j)==1
                M1_new(i,j)=1;
            end
            if Map2(i,j-1)==1 && Map2(i-1,j)==1 && Map2(i+1,j)==1
                M2_new(i,j)=1;
            end
        elseif i==image_height/3 && j~=1
             if Map1(i-1,j)==1 && Map1(i,j-1)==1 && Map1(i,j+1)==1
                M1_new(i,j)=1;
             end
             if Map2(i-1,j)==1 && Map2(i,j-1)==1 && Map2(i,j+1)==1
                M2_new(i,j)=1;
            end
             
        elseif i==1 && j~=1 && j~=image_width/3
             if Map1(i+1,j)==1 && Map1(i,j-1)==1 && Map1(i,j+1)==1
                M1_new(i,j)=1;
             end
             if Map2(i+1,j)==1 && Map2(i,j-1)==1 && Map2(i,j+1)==1
                M2_new(i,j)=1;
             end
        elseif i~=1 && j==1 && i~=image_height/3
             if Map1(i,j+1)==1 && Map1(i-1,j)==1 && Map1(i+1,j)==1
                M1_new(i,j)=1;
            end
            if Map2(i,j+1)==1 && Map2(i-1,j)==1 && Map2(i+1,j)==1
                M2_new(i,j)=1;
            end   
        else
             if Map1(i-1,j)==1 && Map1(i+1,j)==1 && Map1(i,j-1)==1 && Map1(i,j+1)==1
                M1_new(i,j)=1;
            end
            if Map2(i-1,j)==1 && Map2(i+1,j)==1 && Map2(i,j-1)==1 && Map2(i,j+1)
                M2_new(i,j)=1;
            end
        end
    end
end



% watermark based refinement
%input Map1,Map2, CW water MSB, CW water LSB

for i=1:image_height
    for j=1:image_width
        if i==1 && j==1
            R_X_k_hbp(i,j)=bitxor(I_R_original_msb(1,2),I_R_original_msb(2,1));
            R_X_k_lbp(i,j)=bitxor(I_R_original_lsb(1,2),I_R_original_lsb(2,1));
        elseif i==image_height && j==image_width
            R_X_k_hbp(i,j)=bitxor(I_R_original_msb(i,j-1),I_R_original_msb(i-1,j));
            R_X_k_lbp(i,j)=bitxor(I_R_original_lsb(i,j-1),I_R_original_lsb(i-1,j));
        elseif i==1 && j==image_width
            R_X_k_hbp(i,j)=bitxor(I_R_original_msb(1,image_width-1),I_R_original_msb(2,image_width));
            R_X_k_lbp(i,j)=bitxor(I_R_original_lsb(1,image_width-1),I_R_original_lsb(2,image_width));
        elseif i==image_height && j==1
            R_X_k_hbp(i,j)=bitxor(I_R_original_msb(image_height-1,1),I_R_original_msb(image_height,2));
            R_X_k_lbp(i,j)=bitxor(I_R_original_lsb(image_height-1,1),I_R_original_lsb(image_height,2));
        elseif i~=1 && j==image_width
            R_X_k_hbp(i,j)=bitxor(I_R_original_msb(i,image_width-1),bitxor(I_R_original_msb(i-1,image_width),I_R_original_msb(i+1,image_width)));
            R_X_k_lbp(i,j)=bitxor(I_R_original_lsb(i,image_width-1),bitxor(I_R_original_lsb(i-1,image_width),I_R_original_lsb(i+1,image_width)));
        elseif i==image_height && j~=1
            R_X_k_hbp(i,j)=bitxor(I_R_original_msb(image_height-1,j),bitxor(I_R_original_msb(image_height,j-1),I_R_original_msb(image_height,j+1)));
            R_X_k_lbp(i,j)=bitxor(I_R_original_lsb(image_height-1,j),bitxor(I_R_original_lsb(image_height,j-1),I_R_original_lsb(image_height,j+1))); 
        elseif i==1 && j~=1 && j~=image_width
            R_X_k_hbp(i,j)=bitxor(I_R_original_msb(i+1,j),bitxor(I_R_original_msb(i,j-1),I_R_original_msb(i,j+1)));
            R_X_k_lbp(i,j)=bitxor(I_R_original_lsb(i+1,j),bitxor(I_R_original_lsb(i,j-1),I_R_original_lsb(i,j+1)));
        elseif i~=1 && j==1 && i~=image_height
            R_X_k_hbp(i,j)=bitxor(I_R_original_msb(i,j+1),bitxor(I_R_original_msb(i-1,j),I_R_original_msb(i+1,j)));
            R_X_k_lbp(i,j)=bitxor(I_R_original_lsb(i,j+1),bitxor(I_R_original_lsb(i-1,j),I_R_original_lsb(i+1,j)));    
        else
            R_X_k_hbp(i,j)=bitxor(bitxor(I_R_original_msb(i-1,j),I_R_original_msb(i+1,j)),bitxor(I_R_original_msb(i,j-1),I_R_original_msb(i,j+1)));
            R_X_k_lbp(i,j)=bitxor(bitxor(I_R_original_lsb(i-1,j),I_R_original_lsb(i+1,j)),bitxor(I_R_original_lsb(i,j-1),I_R_original_lsb(i,j+1)));
        end
    end
end

for i=1:image_height
    for j=1:image_width
        R_bin_Ce_WaterMark_hbp=dec2bin(R_X_k_hbp(i,j),4);
        R_bin_Ce_WaterMark_lbp=dec2bin(R_X_k_lbp(i,j),3);
        R_ce_wm_hbp(i,j)=bin2dec(R_bin_Ce_WaterMark_hbp(3:4));
        R_ce_wm_lbp(i,j)=bin2dec(R_bin_Ce_WaterMark_lbp(2:3));
    end
end

%put generated watermark into block
Gen_CE_hbp = im2double(R_ce_wm_hbp);
Gen_CE_lbp = im2double(R_ce_wm_lbp);
[m,n] = size(Gen_CE_hbp);
Gen_CE_hbp_Block = cell(m/3,n/3);
Gen_CE_lbp_Block = cell(m/3,n/3);
counti = 0;
for i = 1:3:m-2
   counti = counti + 1;
   countj = 0;
   for j = 1:3:n-2
        countj = countj + 1;
        Gen_CE_hbp_Block{counti,countj} = Gen_CE_hbp(i:i+2,j:j+2);
        Gen_CE_lbp_Block{counti,countj} = Gen_CE_lbp(i:i+2,j:j+2);
   end
end

C1= Gen_CE_hbp_Block;
C2= Gen_CE_lbp_Block;

NewMap1=M1_new;
NewMap2=M2_new;
for i=1:image_height/3
    for j=1:image_width/3
        if NewMap1(i,j)==1
            if isequal(C1{i,j},CE_MSB_Block{i,j})
                NewMap1(i,j)=0;
            end
        end
        if NewMap2(i,j)==1
            if isequal(C2{i,j},CE_LSB_Block{i,j})
                NewMap2(i,j)=0;
            end
        end
    end
end

%Block expansion

[nx ny] = size(NewMap1);
bigFactor = 3;
F_NewMap1 = zeros(bigFactor*nx,bigFactor*ny);
F_NewMap2 = zeros(bigFactor*nx,bigFactor*ny);
for ix = 1:nx
    for iy = 1:ny
        F_NewMap1(1+bigFactor*(ix-1):bigFactor*ix,1+bigFactor*(iy-1):bigFactor*iy) = NewMap1(ix,iy);
        F_NewMap2(1+bigFactor*(ix-1):bigFactor*ix,1+bigFactor*(iy-1):bigFactor*iy) = NewMap2(ix,iy);
    end
end




%regeneration of image
%inputs
recoverd_image=zeros(image_height,image_width);
NewMSB=M;
NewLSB=L;




Wm=R1;
Wl=R2;
% and new maps
for i=1:image_height
    for j=1:image_width
        %generate newMSB and newLSB
        if F_NewMap1(i,j)==1 && F_NewMap2(i,j)~=1
            NewMSB(i,j)=Wm(i,j);
            NewLSB(i,j)=L(i,j);
        end   
        if F_NewMap2(i,j)==1 && F_NewMap1(i,j)~=1
            NewMSB(i,j)=M(i,j);
            NewLSB(i,j)=Wl(i,j);
        end
        if F_NewMap1(i,j)==1 && F_NewMap2(i,j)==1
            NewMSB(i,j)=Wm(i,j);
            NewLSB(i,j)=Wl(i,j);
        end
        recoverd_image(i,j)=strcat(NewMSB(i,j),NewLSB(i,j));
    end
end

final_recovered_image=uint8((bin2dec(string(recoverd_image))));
        
        
        
        
        
        
        
        
        
        
        
        