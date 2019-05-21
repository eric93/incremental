* Motivation
  * Writing correct incremental layout engines is hard **TODO: justify with Servo bugs**
* Contribution
  * We have built a tool called **XXX** that enables developers to explore the space of incremental layout engines, with the guarantee that any incremental engine they produce is correct.
* Implementation
  * Incrementalization is a compilation backend that takes in a schedule and produces an optimized layout engine in the target language.
  * Phase 1: Schedule translation
    * Goal: translate a schedule to a schedule with dirty bits.
    * Choices during translation:
      * Dirty-bit Aggregation (only adjacent attributes allowed to aggregate; strongly depends on schedule)
      * Whether to dynamically check for change or not.
      * If not, what function to compute the dirty bit with (precision/complexity tradeoff)
    * **TODO Theorem: any set of choices produces a sound incremental schedule**
  * Phase 2: Code generation
    * Goal: generate efficient code for incremental updates
    * Open Questions (i.e. these are all **TODO**)
      * How do we choose when to start/stop a traversal?
      * Where do we store old vs. new values for attributes (it's inconvenient to store both)?
      * How do we ensure we don't introduce unnecessary overhead (**TODO: be more specific**)?
* Evaluation
  * Research Question: Do we capture the entire space of layout engines developers want to write?
    * **TODO: Answer.** Possible Answers:
      * Show a bunch of case studies covering a wide range of layout features **TODO: find case studies; this sounds hard**
      * Our tool is sophisticated enough to handle features that cause bugs in existing browsers **TODO: we have some Servo bugs, but we would probably want Webkit, Gecko, and Blink! bugs as well**
      * Some kind of user study or study of popular dynamic web pages?
  * Threats to validity
    * Objection 1: Scheduling and incrementality are inseperable
      * Objection 1.1: Dirty-bit aggregation is strongly schedule-dependent
        * Response: We have modified our scheduler to account for this
      * Objection 1.2: What if I want to schedule dirty-bit computation at a different point than attribute computation?
        * Response: This is suboptimal under a basic cost model. If we
        assume that every attribute function (including dirty-bit attributes)
        has an intrinsic time to compute, and each traversal has some intrinsic
        overhead, it makes sense to schedule dirty bits as close as possible to
        the attributes they are associated with. Developers currently write
        traversals that entirely focus on dirty bit computation for conceptual
        and code-readability reasons. Our tool makes these considerations
        unnecessary. **TODO: make precise**
    * Objection 2: What about low-level implementation concerns (e.g. data structures used, data layout, simplifying functions, etc.)?
      * Response 1: Developers can somewhat control this with the types they give to attributes and the attribute value functions they reference in the grammar.
      * Response 2: For other concerns, there is a best answer and our implementation chooses that one **TODO: be specific about concerns and make sure this is true**
