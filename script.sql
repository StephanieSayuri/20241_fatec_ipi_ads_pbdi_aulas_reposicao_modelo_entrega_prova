-- ----------------------------------------------------------------
-- 1 Base de dados e criação de tabela
--escreva a sua solução aqui
CREATE TABLE student_prediction (
    id SERIAL PRIMARY KEY, 
    salary INT, 
    mother_edu INT, 
    father_edu INT, 
    prep_study INT, 
    prep_exam INT,
    grade INT
);

-- ----------------------------------------------------------------
-- 2 Resultado em função da formação dos pais
--escreva a sua solução aqui
DO
$$
DECLARE
  -- 1. Declaração do cursor
    cur_n_alunos REFCURSOR;
    v_numero INT;

BEGIN
    -- 2. Abertura do cursor
    OPEN cur_n_alunos FOR 
        SELECT COUNT(*) FROM student_prediction WHERE grade <> 0 AND mother_edu = 6 OR father_edu = 6;

    LOOP
        -- 3. Recuperação dos dados de interesse
        FETCH cur_n_alunos INTO v_numero;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE 'Número de alunos: %', v_numero;
    END LOOP;

    -- 4. fechamento do cursor
    CLOSE cur_n_alunos;
END;
$$;

-- ----------------------------------------------------------------
-- 3 Resultado em função dos estudos
--escreva a sua solução aqui
DO
$$
DECLARE
    -- 1. declaração do cursor
    cur_n_alunos REFCURSOR;
    v_numero INT;

BEGIN
    -- 2. abertura do cursor
    OPEN cur_n_alunos FOR EXECUTE
    FORMAT (
        'SELECT COUNT(*) FROM student_prediction WHERE grade > %s AND prep_study = %s', 0, 1
    );

    LOOP
        -- 3. recuperação dos dados de interesse
        FETCH cur_n_alunos INTO v_numero;
        EXIT WHEN NOT FOUND;

        IF v_numero IS NULL THEN
        v_numero := -1;
        END IF;
        RAISE NOTICE 'número de alunos: %', v_numero;
    END LOOP;

    -- 4. fechamento do cursor
     CLOSE cur_n_alunos;
END;
$$;

-- ----------------------------------------------------------------
-- 4 Salário versus estudos
--escreva a sua solução aqui
DO
$$
DECLARE
    -- 1. declaração do cursor
    cur_n_alunos cursor FOR 
        SELECT COUNT(*) FROM student_prediction WHERE salary = 5 AND prep_exam = 2;

    v_numero INT;

BEGIN
    -- 2. abertura do cursor
    OPEN cur_n_alunos;

    LOOP
        -- 3. recuperação dos dados de interesse
        FETCH cur_n_alunos INTO v_numero;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE 'número de alunos: %', v_numero;
    END LOOP;

    -- 4. fechamento do cursor
    CLOSE cur_n_alunos;
END;
$$;

-- ----------------------------------------------------------------
-- 5. Limpeza de valores NULL
--escreva a sua solução aqui
DO
$$
DECLARE
    -- 1. declaração do cursor
    cur_n_alunos cursor FOR 
        SELECT * FROM student_prediction;
    v_tupla record;
BEGIN
    -- 2. abertura do cursor
    OPEN cur_n_alunos;

    LOOP
        -- 3. recuperação dos dados de interesse
        FETCH cur_n_alunos INTO v_tupla;
        EXIT WHEN NOT FOUND;

        IF v_tupla.salary IS NULL OR v_tupla.mother_edu IS NULL OR v_tupla.father_edu IS NULL OR  v_tupla.prep_exam IS NULL OR v_tupla.grade IS NULL THEN
        DELETE FROM student_prediction WHERE CURRENT OF cur_n_alunos;
        END IF;
    END LOOP;

    -- 4. fechamento do cursor
    CLOSE cur_n_alunos;
END;
$$;
-- ----------------------------------------------------------------