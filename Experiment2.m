function [out] = Experiment2(in)
      out=[ ];
      [num,~]=size(in);
      for i=1:num
          out=[out; ELM_Kernel_t(in(num))];
      end
end

