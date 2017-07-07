function [out] = Experiment1(in)
      out=[ ];
      [num,~]=size(in);
      X=in(:,1);
      Y=in(:,2);
      for i=1:num
          out=[out; PISI(X(num),Y(num))];
      end
end

