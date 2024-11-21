classdef Experiment1
    properties
        M                   % Constellation order
        m                   % Bits per symbol
        nSym; nBits;        % Number of symbols and bits in the simulation
        tAssig              % Type of binary assignement ('gray', 'bin')

        x; N;               % Spreading sequence and its length
        
        p; d;               % Equivalent channels in regular and chip time
        B; A;               % Tx Bits and Symbols
        o; q;               % Rx Symbols before and after noise
    end

    methods

        function obj = Experiment1(M, nSym, tAssig, d, x)
            obj.M = M;
            obj.m = log2(M);
            obj.nSym = nSym;
            obj.nBits = nSym*m;
            obj.tAssig = tAssig;

            obj.d = d;

            obj.x = x;
            obj.N = length(x);
        end

        function p = init(obj)

            % Find the p equivalent channel
            p = DSSS_p(obj.d, obj.x);
            
            % Digital QAM Modulator
            obj.B = randi([0 1], obj.nBits, 1); % Random bits
            obj.A = qammod(obj.B, obj.M, obj.tAssig, InputType='bit'); % Symbols

            % Discrete equivalent channel
            obj.o = conv(obj.A, p);
            obj.o = obj.o(1:nSym);

            % Get noisy sequence
            obj.q = awgn(o, snrb, 10*log10(Eb));
        end

        % Get noisy sequence, estimated bits, BER, and SER
        function [Be, BER, SER] = exec(obj, nVar)
            m = log2(M);

            % -- Apply delay d
            % - Eliminate first d observations (info about A[n], n<0)
            q_d = q(d+1:end);   % q[d] ... q[N], which is info about A[0] ... A[N-d]
            % - Truncate last m*d bits (estimation requires q[N+1] ... q[N+d])
            B_d = B(1:end-m*d); % B[0] ... B[m(N-d)]

            % Apply q compensation factor
            q_d = qfactor*q_d;
            
            % Get demodulated bits A[0] ... A[N-d]
            Be = qamdemod(q_d, M, tAssig, OutputType='bit');
            % Bit and symbol error rates
            [~, BER, Berrs] = biterr(B_d, Be);
            SER = symerr(Berrs, M);
        end
    end
end




