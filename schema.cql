CREATE KEYSPACE IF NOT EXISTS storage_document WITH replication={'class':'NetworkTopologyStrategy', 'DC1':'1'};

CREATE TYPE IF NOT EXISTS storage_document.party_id (
    id_type TEXT,
    value TEXT
);

CREATE TYPE IF NOT EXISTS storage_document.address (
    country TEXT,
    country_code TEXT,
    post_code TEXT,
    province TEXT,
    street TEXT,
    street2 TEXT,
    town TEXT,
    post_box TEXT
);

CREATE TYPE if NOT EXISTS storage_document.contact (
    name TEXT,
    phone TEXT,
    email TEXT,
    fax TEXT,
    web_page TEXT
);

CREATE TYPE IF NOT EXISTS storage_document.attachment (
    name TEXT,
    storage_id TEXT,
    presentation BOOLEAN,
    legal BOOLEAN,
    misc BOOLEAN,
    mime_type TEXT,
    primary_presentation BOOLEAN,
    resource_id TEXT,
    distributed BOOLEAN,
    created_date TIMESTAMP,
    doc_hash TEXT,
    hash_algorithm TEXT
);

CREATE TYPE storage_document.event(
    action text,
    user text,
    time TIMESTAMP
);

CREATE TABLE IF NOT EXISTS storage_document.documents (
    resource_id TEXT,
    create_time_message_service TIMESTAMP,
    send_type TEXT,
    document_type TEXT,
    document_identifier TEXT,
    document_date TIMESTAMP,
    document_due_date TIMESTAMP,
    total_amount TEXT,
    total_net_amount TEXT,
    total_vat_amount TEXT,
    currency TEXT,
    source_media_type TEXT,
    document_specific_type_raw TEXT,
    internal_interchange_id TEXT,
    attachments SET<frozen <attachment>>,
    sender_party_resource_id TEXT,
    sender_party_name TEXT,
    sender_party_ids SET<frozen <party_id>>,
    sender_party_address frozen <address>,
    sender_party_contact frozen <contact>,
    sender_party_personal_contact frozen <contact>,
    sender_party_department TEXT,
    sender_party_unit_number TEXT,
    sender_party_erp_id TEXT,
    receiver_party_resource_id TEXT,
    receiver_party_name TEXT,
    receiver_party_ids SET<frozen <party_id>>,
    receiver_party_address frozen <address>,
    receiver_party_contact frozen <contact>,
    receiver_party_personal_contact frozen <contact>,
    receiver_party_department TEXT,
    receiver_party_unit_number TEXT,
    receiver_party_erp_id TEXT,
    auth_company_id TEXT,
    service_provider TEXT,
    distribution_type TEXT,
    recipient_service_provider TEXT,
    direction TEXT,
    file_name TEXT,
    create_time_document_service TIMESTAMP,
    events SET<frozen <event>>,

    PRIMARY KEY(auth_company_id, internal_interchange_id)
);
