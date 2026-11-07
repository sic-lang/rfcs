# Vision: Key-Value Store

Clients and a server sharing a key-value store over a network, developed top-down from a three-line specification down to a lossy network.
This running example lets RFCs show how the mechanisms they propose apply to all the layers of [RFC 13](https://github.com/sic-lang/rfcs/pull/13) at once.
The notation below is not a syntax proposal.

## Scope

The system works for any number of clients, including none.
Liveness (every request is eventually answered) and server failures are left open for now.

## Level 1: System

```text
spec KV
  state  m : Key → Option Value                       -- ghost
  op put(k, v) → Ok | Full    ensures result = Ok   ⇒ m' = m[k ↦ v]
                              ensures result = Full ⇒ m' = m
  op get(k)    → Option Value ensures result = m(k) ∧ m' = m
```

This is the only global statement of the system.
The state `m` is ghost: it exists only for the specification, checked like any other value but erased from the compiled program, so it costs nothing at run time.
With several clients, operations are linearizable: each takes effect atomically at some point between its call and its return.
`Full` comes from level 3: a refinement cannot add a behavior that the level above forbids, so the capacity of the store must appear here.
Top-down development does not mean that upper levels never change, but that the compiler tells exactly which proof obligations a change breaks.

## Level 2: Clients, Server and Channels

```text
protocol G =                                    -- global protocol, between each client and the server
  loop Client → Server {
    Put(k, v). Server → Client { Ok | Full }. loop
    Get(k).    Server → Client Value(Option Value). loop
    Close.     end
  }

G ↾ Client = !{ Put. ?{Ok | Full} | Get. ?Value | Close }  -- projections
G ↾ Server = dual (G ↾ Client)

spec Server   state ms : Key → Option Value  -- serves all clients, one request at a time, from ms
spec Client   -- each call to put or get makes exactly one round of the protocol
spec Channel  -- reliable and FIFO, one per client

gluing  m = ms
PO2 : (Client₁ ∥ … ∥ Clientₙ) ∥ Channels ∥ Server ⊑ KV   -- for every n ≥ 0
```

The session endpoint of each client is linear: it cannot send two requests without reading the answer, nor forget `Close`.
Because the server handles one request at a time, the linearization point of each operation is its handling by the server, and `ms` needs no lock.
Serving clients concurrently would share `ms` between threads: that sharing, and the deadlocks it can bring, are what the type system must rule out, as long as the specification is right.
The protocol notation comes from [multiparty session types](https://doi.org/10.1145/1328438.1328472) and only illustrates the decomposition: whether protocols are a construct of Sic is left to the RFCs on linear types.

## Level 3a: Server

```text
spec Store            -- the operations of KV, on its own abstract state s
impl HashStore : Store
  state  slots : unique Array[N] (Empty | Full(Key, Value))  -- fixed buffer, no allocation
  gluing s(k) = v  ⇔  ∃ i. slots[i] = Full(k, v)
  inv    unique keys ∧ no Empty between hash(k) and the slot of k (linear probing)

PO3a : HashStore ⊑ Store                -- data refinement
PO3b : Handler ∘ Store ⊑ Server         -- sees only the Store specification, never the array
```

The buffer must be unique, not only linear, to be updated in place.

## Level 3b: Client

```text
resource Conn                                    -- linear
op connect(addr) → Result Conn
op close(c : Conn) → ()                          -- consumes c

PO3c : Api ∘ Conn ⊑ Client
```

## Level 4: Network

```text
impl StopAndWait(Lossy) : Channel
  Lossy  : may lose, duplicate and reorder messages
  state  seq_tx, seq_rx, in_flight : Option Message
  gluing the delivered sequence is a prefix of the sent sequence ∧ at most one message in flight

PO4 : StopAndWait(Lossy) ⊑ Channel
```

Replacing the reliable channel by a real network only requires PO4: nothing above level 4 is proved again.

## What It Exercises

| Layer | Where |
| --- | --- |
| Dependent types | Specifications as types, proof obligations PO2 to PO4, invariant of the hash table |
| Linear types | Session of the client, `Conn`, unique buffer, ghost state of level 1 (erased) |
| Refinement | Four levels, decompositions (PO2, PO3b, PO3c), data refinements (PO3a, PO4) |
| Explicitness, low-level programming | Fixed buffer, no hidden allocation, capacity visible in the type of `put` |
| Readability | The specification `KV` must be validated by a human at a glance |

## Open Questions

- Liveness: proving that every request is answered needs a fairness assumption on `Lossy`.
- Server failures: [crash-stop failures in multiparty session types](https://arxiv.org/abs/2207.02015).
- Ghost or executed: `m` is ghost and `ms` is executed; the boundary must be visible at a glance.
