# user serviceable commands
ASCIIDOC=asciidoctor
MAKEDEP=./deps.rb

# create the output and aux directories
OUTDIR := output
DEPDIR := .d
STAMPDIR := .stamp

$(shell mkdir -p $(OUTDIR) >/dev/null)
$(shell mkdir -p $(DEPDIR) >/dev/null)
$(shell mkdir -p $(STAMPDIR) >/dev/null)


# create dependency rules from the source files
$(DEPDIR)/%.d: %.adoc
	@$(MAKEDEP) $^ 1>$(DEPDIR)/$*.d

.PRECIOUS: $(DEPDIR)/%.d


# build the output if the toplevel, rules, or dependency timestamps have changed
$(OUTDIR)/%.html: %.adoc $(DEPDIR)/%.d $(STAMPDIR)/%.adoc.stamp
	$(ASCIIDOC) --backend=html5 --out-file=$@ $<


# generic whole project rules
html5: $(OUTDIR)/all.html $(OUTDIR)/README.html

all: html5


clean:
	rm -f $(DEPDIR)/*.d
	rm -f $(OUTDIR)/*.html
	rm -f $(STAMPDIR)/*.stamp

.PHONY: html5 all clean


# source listings
SRC =	README.adoc

#include the dependency rules
-include $(patsubst %,$(DEPDIR)/%.d,$(basename $(SRC)))
