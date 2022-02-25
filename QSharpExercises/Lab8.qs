﻿// Lab 8: The Quantum Fourier Transform
// Copyright 2021 The MITRE Corporation. All Rights Reserved.

namespace QSharpExercises.Lab8 {

    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;


    /// # Summary
    /// In this exercise, you must implement the Quantum Fourier Transform
    /// circuit. This will perform an in-place transformation of the
    /// amplitudes of each state in the superposition from the
    /// value-versus-time to the value-versus-frequency domain.
    /// 
    /// # Input
    /// ## register
    /// A register containing qubits in superposition.
    /// The superposition is unknown, and the amplitudes are not guaranteed to
    /// be uniform.
    operation Exercise1 (register : BigEndian) : Unit is Adj + Ctl {
        // Hint: there are two functions you may want to use here:
        // the first is your implementation of register reversal in Lab 2,
        // Exercise 2.
        // The second is the Microsoft.Quantum.Intrinsic.R1Frac() gate.
        RecursivePart(register!);

        // Reverse the register
        SwapReverseRegister(register!);
    }

    operation RecursivePart (register : Qubit[]) : Unit is Adj + Ctl {
        H(register[0]);
        if Length(register) > 1 {
            for i in 1 .. Length(register) - 1{
                Controlled R1Frac([register[i]], (2, 1+i, register[0]));
            }

            RecursivePart(Rest(register));
        }
    }
    /// # Summary
    /// In this exercise, you are given a quantum register in an unknown
    /// superposition. In this superposition, a single sine wave has been
    /// encoded into the amplitudes of each term in the superposition.
    /// 
    /// For example: the first sample of the wave will be the amplitude of the
    /// |0> term, the second sample of the wave will be the amplitude of the
    /// |1> term, the third will be the amplitude of the |2> term, and so on.
    /// 
    /// Your goal is to find the frequency of these samples, and return that
    /// frequency.
    /// 
    /// # Input
    /// ## register
    /// The register which contains the samples of the sine wave in the
    /// amplitudes of  its terms.
    /// 
    /// ## sampleRate
    /// The number of samples per second that were used to collect the
    /// original samples. You will need this to retrieve the correct
    /// frequency.
    /// 
    /// # Output
    /// The frequency of the sine wave.
    operation Exercise2 (
        register : BigEndian,
        sampleRate : Double
    ) : Double {
        Adjoint Exercise1(register);
        mutable output = MeasureInteger(BigEndianAsLittleEndian(register));

        let numSamps = 2^Length(register!);
        if output > numSamps / 2 {
            set output = numSamps - output;
        }

        return IntAsDouble(output) * (sampleRate / IntAsDouble(numSamps));
    }
}