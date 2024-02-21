function Y = SurfStatSmooth( srf, Y, FWHM, metric )

%Smooths surface data by repeatedly averaging over edges.
%
% Usage: Y = SurfStatSmooth( Y, surf, FWHM );
% 
% Y        = n x v or n x v x k matrix of surface data, v=#vertices;
%            n=#observations; k=#variates, or memory map of same.
% surf.faces = t x 3 matrix of triangle indices, 1-based, t=#triangles.
% or
% surf.lat = nx x ny x nz matrix, 1=in, 0=out, [nx,ny,nz]=size(volume). 
% FWHM     = approximate FWHM of Gaussian smoothing filter, in mesh units.
%
% Note that if the data is memory mapped, then the data is overwriten by
% the smoothed data.

if ~exist('metric', 'var')
    metric = 'ones';
end

niter=ceil(FWHM^2/(2*log(2)));

if isnumeric(Y)
    [n,v,k]=size(Y);
    isnum=true;
else
    Ym=Y;
    s=Ym.Format{2};
    if length(s)==2
        s=s([2 1]);
        k=1;
    else
        s=s([3 1 2]);
        k=s(3);
    end
    n=s(1);
    v=s(2);
    isnum=false;
end

edg = SurfStatEdg(srf);
if strcmp(metric, 'dist')
    first_set = srf.vertices(edg(:,1),:);
    second_set = srf.vertices(edg(:,2),:);
    dist = double(sqrt(sum((first_set - second_set).^2,2)));
    dist = 1./dist;
end

% This counts the number of occurences of each vertex of each edge and
% multiplies that by 2!
if strcmp(metric, 'ones')
    Y1 = accumarray(edg(:,1),2,[v 1])'+accumarray(edg(:,2),2,[v 1])';
elseif strcmp(metric, 'dist')
    % Ensure that the weights scale to 1
    Y1=accumarray(edg(:,1),dist,[v 1])'+accumarray(edg(:,2),dist,[v 1])';
    % Multiply by a factor of 2 to ensure you're averaging!
    Y1 = 2*Y1;
end

if n>1
    fprintf(1,'%s',[num2str(n) ' x ' num2str(k) ' surfaces to smooth, % remaining: 100 ']);
end
n10=floor(n/10);
for i=1:n
    if rem(i,n10)==0
        fprintf(1,'%s',[num2str(100-i/n10*10) ' ']);
    end
    for j=1:k
        if isnum
            Ys=squeeze(Y(i,:,j));
            for iter=1:niter
                % To change to an arbitrary distance metric need to
                % multiply this step by some distance measure dist.
                Yedg=Ys(edg(:,1))+Ys(edg(:,2)); 
                if strcmp(metric, 'dist')
                    Yedg=Yedg.*dist'; 
                end
                % The thing to add an accumlate ...
                % at each round! Note that it doesn't average here which is why
                % line 41 includes a multiple of 2 so that it can be divided by it here
                Ys=(accumarray(edg(:,1),Yedg',[v 1]) + ...
                    accumarray(edg(:,2),Yedg',[v 1]))'./Y1;
            end
            Y(i,:,j)=Ys;
        else
            if length(s)==2
                Y=Ym.Data(1).Data(:,i);
            else
                Y=Ym.Data(1).Data(:,j,i);
            end            
            for iter=1:niter
                Yedg=Y(edg(:,1))+Y(edg(:,2));
                Y=(accumarray(edg(:,1),Yedg',[v 1]) + ...
                    accumarray(edg(:,2),Yedg',[v 1]))'./Y1;
            end
            if length(s)==2
                Ym.Data(1).Data(:,i)=Y;
            else
                Ym.Data(1).Data(:,j,i)=Y;
            end            
        end
    end
end
if n>1
    fprintf(1,'%s\n','Done');
end
if ~isnum
    Y=Ym;
end

return
end