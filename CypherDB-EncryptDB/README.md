# CypherDB program to modify SQLite database with encrypted data

SelectedFieldEnc_workbench:
Create an encrypted database and OPE index
an encryption vector is used to select the fields to be encrypted

SelectedFieldEnc_WithoutOPE_workbench:
Create an encrypted databse without OPE index
It is used without index

SelectedFieldEnc_unprotected_IDX:
Create an encrypted database with unencrypted index
the index field has to be unencrypted

SelectedFieldEnc_extra_unprotected_IDX:
Create an encrypted database with unencrypted index
The method is a bit tricky. The best case is actually preserve the the field unencrypted.
To save effort, in the current prototype. the whole tuple is encrypted. but with extra field which is unencrypted to serve as an index.
