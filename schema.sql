/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    id INT NOT NULL,
    name VARCHAR(100),
    date_of_birth DATE,
    escape_attempts INT,
    neutered BOOLEAN,
    weight_kg DECIMAL,
    PRIMARY KEY(id)
);

/* Add species column to animal table */
ALTER TABLE animals
ADD COLUMN species VARCHAR(100);

/*QueryMulti*/
CREATE TABLE owners (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    age INT
);

/* Create species table */
CREATE TABLE species (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100)
);

/* Remove species column */
ALTER TABLE animals DROP COLUMN species;

/* Add species_id in animals table referenced from species table */
ALTER TABLE animals ADD COLUMN species_id INT REFERENCES species (id);

/* Add owners_id in animals table referenced from owners table */
ALTER TABLE animals ADD COLUMN owners_id INT REFERENCES owners (id);


/* JoinTable*/
/* Create vets table */
CREATE TABLE vets (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    date_of_graduation DATE
);

/* Create join/bridge table specializations */
CREATE TABLE specializations (
    vets_id INT NOT NULL,
    species_id INT NOT NULL,
    FOREIGN KEY (vets_id) REFERENCES vets (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (species_id) REFERENCES species (id) ON DELETE RESTRICT ON UPDATE CASCADE
);

/* Create join/bridge table visits */
CREATE TABLE visits (
    vets_id INT NOT NULL,
    animals_id INT NOT NULL,
    date_of_visit DATE,
    FOREIGN KEY (vets_id) REFERENCES vets (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (animals_id) REFERENCES animals (id) ON DELETE RESTRICT ON UPDATE CASCADE
);
