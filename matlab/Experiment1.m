classdef Experiment1 < handle

properties
    M      (1,1)    % Constellation order
    m      (1,1)    % Bits per symbol
    nSym   (1,:)    % Number of symbols in the simulation
    nBits  (1,:)    % Number of bits in the simulation
    tAssig (1,:)    % Type of binary assignement ('gray', 'bin')
    nVar   (1,1)    % Noise variance
    delay  (1,1) = 0 % Decision delay
    p; d;           % Equivalent channels in regular and chip time
    x; N;           % Spreading sequence and its length

    B; A; s;        % Tx Bits, Symbols, and spread Chip sequence
    v; q;           % Rx Chip sequence and despread Symbols
    Be; Ae;         % Estimated bits and symbols

    BER; SER;       % Bit and symbol error rates of the last run
end

methods

    % == Constructor ==
    function obj = Experiment1(M, nSym, tAssig, d, x)
        obj.nSym = nSym;
        obj.M = M; % Also sets m and nBits
        obj.tAssig = tAssig;
        obj.d = d;
        obj.x = x; % Also sets N and p
    end
    
    % == Getters and setters ==
    function set.M(obj, M)
        obj.M = M;
        obj.m = log2(obj.M); %#ok<MCSUP>
        obj.nBits = obj.nSym * obj.m; %#ok<MCSUP>
    end
    function set.x(obj, x)
        obj.x = x;
        obj.N = length(x); %#ok<MCSUP>
        obj.p = DSSS_p(obj.x, obj.d); %#ok<MCSUP>
    end

    % == Steps ==
    function B = gen(obj)
    % Generate initial sequence of random bits to be sent as well as their
    % decimal representation

        obj.B = randi([0 1], 1, obj.nBits);
        B = obj.B;
    end

    function A = encode(obj, B)
    % Encode bits into symbols
        arguments
            obj;
            B (1, :) = obj.B % Bits to encode
        end
        if (isempty(B)); error('Missing B sequence. Run gen() first.'); end

        % Bits in groups of m
        %// Bsimb = zeros(m,nSimb);
        %// Bsimb(:) = B;
        % NOTE: The `reshape` function does exactly what the demo code did, but
        % it's faster and simpler
        Bsym = reshape(B, [obj.m, obj.nSym]);
        % Decimal representation of every m bits
        %// Bdec = transpose(bin2dec(num2str(Bsimb')));
        % NOTE: The `bit2int` function does exactly what the demo code did but
        % it's almost 2 orders of magnitude faster and much simpler
        Bdec = bit2int(Bsym, obj.m);

        obj.A = pammod(Bdec, obj.M, 0, obj.tAssig);
        A = obj.A;
    end

    function s = spread(obj, A)
    % Generate spread chip sequence from encoded symbols
        arguments
            obj
            A (1, :) = obj.A % Bits to encode
        end
        if (isempty(A)); error('Missing encoded A sequence. Run encode() first.'); end
            
        obj.s = kron(A, obj.x);
        s = obj.s;
    end

    function v = transmit(obj, nVar, s)
    % Get output sequence at chip time after transmission and noise
        arguments
            obj
            nVar (1,1)       % Noise variance
            s (1, :) = obj.s % Spread chip symbols
        end
        if (isempty(s)); error('Missing modulating s sequence. Run modulate() first.'); end

        % Transmission through equivalent channel at chip time
        obj.v = convn(s, obj.d); obj.v = obj.v(1:length(s));
        % Adding noise. Normalized input noise.
        obj.v = obj.v + sqrt(nVar)*randn(size(obj.v));

        v = obj.v;
    end

    function q = despread(obj, v)
    % Despread received sequence to get symbols in normal time
        arguments
            obj
            v (1, :) = obj.v % Rx symbols at chip time
        end
        if (isempty(v)); error('Missing received v sequence. Run transmit() first.'); end

        % Un-spread v sequence by multiplying it by the conjugate of the
        % spreading sequence and adding every N samples
        obj.q = sum(reshape(v, obj.N, []).*conj(obj.x'));
        q = obj.q;
    end

    function [Be, Ae] = decode(obj, q)
    % Decode normal-time received symbols into estimated bits and symbols
        arguments
            obj
            q (1, :) = obj.q % Rx symbols at normal time
        end
        if (isempty(q)); error('Missing despread q sequence. Run despread() first.'); end

        qn = q/obj.p(obj.delay+1); % Normalized q

        % Decimal representation of every symbol
        Be_dec = pamdemod(qn, obj.M, 0, obj.tAssig);
        % Binary representation of every number in Be_dec
        obj.Be = reshape(int2bit(Be_dec, obj.m), 1, []);
        % Estimated symbols
        obj.Ae = pammod(Be_dec, obj.M, 0, obj.tAssig);

        Be = obj.Be; Ae = obj.Ae;
    end

    function [BER, SER] = evalErrors(obj, B, A, Be, Ae)
        arguments
            obj
            B  (1, :) = obj.B % Rx symbols at normal time
            A  (1, :) = obj.A % Rx symbols at normal time
            Be (1, :) = obj.Be % Rx symbols at normal time
            Ae (1, :) = obj.Ae % Rx symbols at normal time
        end
        if (isempty(B)); error('Missing input and output bit and symbol sequences'); end

        [~, obj.BER] = biterr(B, Be);
        obj.SER = sum(Ae ~= A)/length(A);
        BER = obj.BER; SER = obj.SER;
    end

end

end